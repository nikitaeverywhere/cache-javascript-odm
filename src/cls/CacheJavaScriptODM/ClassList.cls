Class CacheJavaScriptODM.ClassList
{

ClassMethod WriteJSON(namespace As %String, classList As %String) As %Status
{
    zn:$GET(namespace)'="" namespace
    set classList = "," _ classList
    
    set root = ##class(%ZEN.proxyObject).%New()
    set classes = ##class(%ZEN.proxyObject).%New()
    set root.classes = classes
    set root.token = "test123"

    set classRes = ##class(%ResultSet).%New("%Dictionary.ClassDefinition:Summary")
    do classRes.Execute()

    while (classRes.Next()) {
        set className = classRes.Data("Name")
        if ($EXTRACT(className, 1, 1) = "%") && ($NAMESPACE '= "%SYS") { continue }
        if '((","_className) [ classList) { continue }
        
        set class = ##class(%ZEN.proxyObject).%New()
        set classDefinition = ##class(%Dictionary.CompiledClass).%OpenId(className)
        if (classDefinition = "") {
            //write "{""error"": ""Wrong className""}"
            continue
        }
        
        set count = classDefinition.Properties.Count()
        for i=1:1:count {
            set p = classDefinition.Properties.GetAt(i)
            if ($EXTRACT(p.Name, 1) = "%") { continue }
            set oProp = ##class(%ZEN.proxyObject).%New()
            set oProp.type = "property"
            do class.%DispatchSetProperty(p.Name, oProp)
        }
        
        set count = classDefinition.Methods.Count()
        for i=1:1:count {
            set p = classDefinition.Methods.GetAt(i)
            if ($EXTRACT(p.Name, 1) = "%") { continue }
            set oProp = ##class(%ZEN.proxyObject).%New()
            if (p.ClassMethod) {
                set oProp.type = "classmethod"
            } else {
                set oProp.type = "method"
            }
            do class.%DispatchSetProperty(p.Name, oProp)
        }
        
        do classes.%DispatchSetProperty(className, class)
    }
    
    do root.%ToJSON("o")
    
    quit $$$OK
}

ClassMethod open(namespace As %String = "", className As %String, id As %String) As %Status
{
    zn:(namespace'="") namespace
    set object = $CLASSMETHOD(className, "%OpenId", id)
    // null returned if not found, do not change
    do ##class(%ZEN.Auxiliary.jsonProvider).%ObjectToJSON(object, "o")
    quit $$$OK
}

ClassMethod query(namespace = "", className, conditions, order, aggr)
{
    zn:(namespace'="") namespace
    set sql = "SELECT " _ $case(aggr="", 1: "*", :aggr) _ " FROM " _ className
    set conditions = $REPLACE(conditions, "$id", "ID")
    if (conditions '= "") {
        set list = $LISTFROMSTRING(conditions, ",")
        set sql = sql _ " WHERE"
        set len = $LL(list)
        for i=1:1:len {
            set sql = sql _ " " _ $LISTGET(list, i) _ $case(i'=len, 1:" AND", :"")
        }
    }
    set order = $REPLACE(order, "$id", "ID")
    if (order '= "") {
        set sql = sql _ " ORDER BY " _ order
    }
    do ##class(%ZEN.Auxiliary.jsonSQLProvider).%WriteJSONFromSQL(, sql, "u")
    quit $$$OK
}

/// run method
ClassMethod exec(namespace = "", className, methodName, objectId, params = "")
{
    zn:(namespace'="") namespace
    //w namespace, " ", className, " ", methodName, " ", objectId
    set methodDefinition = ##class(%Dictionary.MethodDefinition).%OpenId(className_"||"_methodName)
    set args = $LISTFROMSTRING(params, ",") // simple
    set g = $LL(args)
    for i=1:1:$LL(args) {
        set g(i) = $LISTGET(args, i)
    }
    if (methodDefinition.ClassMethod) {
        do $CLASSMETHOD(className, methodName, g...)
    } else {
        set obj = $CLASSMETHOD(className, "%OpenId", objectId)
        if (obj = "") {
            write "{""error"":""Unable to open "_className_" with ID="_objectId_"""}"
            quit
        }
        do $METHOD(obj, methodName, g...)
    }
}

ClassMethod updProperties(proxyObject)
{
    set className = $PROPERTY(proxyObject, "$class")
    //w className, !
    set i = 0
    set new = 0
    set obj = $CLASSMETHOD(className, "%OpenId", $PROPERTY(proxyObject, "$id"))
    if (obj = "") { // new object
        set obj = $CLASSMETHOD(className, "%New")
        set new = 1
        if (obj = "") {
            write "{""error"":""FATAL ERROR! Unable to create "_className_"""}"
            quit
        }
    }
    set classDefinition = ##class(%Dictionary.CompiledClass).%OpenId(className)
    //zw proxyObject w !, !
    for j=1:1:classDefinition.Properties.Count() {
        set pname = classDefinition.Properties.GetAt(j).Name
        //w "|", pname, proxyObject.%DispatchGetProperty(pname)
        if (proxyObject.%DispatchGetProperty(pname) '= "") {
            set property = $PROPERTY(proxyObject, pname)
            if ($ISOBJECT(property)) {
                set ret = ..updProperties(property)
                set $PROPERTY(obj, pname) = ret
            } else {
                set $PROPERTY(obj, pname) = $PROPERTY(proxyObject, pname)
                set i = i + 1
            }
        }
    }
    if (i '= 0) {
        set status = obj.%Save()
        if ($$$ISERR(status)) {
            w "{""error"":"""_$System.Status.GetErrorText(status)_"""}"
            quit
        } elseif (new) {
            do ..open(, className, obj.%Id())
        }
    }
    quit obj
}

ClassMethod save(namespace As %String = "", objectJSON) As %Status
{
    zn:(namespace'="") namespace
    //do object.%Save()
    set st = ##class(%ZEN.Auxiliary.jsonProvider).%ConvertJSONToObject(objectJSON, "%ZEN.proxyObject", .object)
    if ($$$ISERR(st)) {
        set error = $System.Status.GetErrorText(st)
        write "{""error"":"""_error_"""}"
        quit $$$ERROR(error)
    }
    
    do ..updProperties(.object)
    
    quit $$$OK
}

}
