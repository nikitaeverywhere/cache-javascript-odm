/// REST interface for CacheJavaScriptODM
Class CacheJavaScriptODM.REST Extends %CSP.REST
{

XData UrlMap
{
<Routes>
   <Route Url="/connect" Method="GET" Call="connect"/> <!-- ?NS=SAMPLES -->
   <Route Url="/open" Method="GET" Call="open"/>
   <Route Url="/save" Method="GET" Call="save"/>
   <Route Url="/query" Method="GET" Call="query"/>
   <Route Url="/exec" Method="GET" Call="exec"/>
</Routes>
}

ClassMethod head() As %Status
{
    #dim %response As %CSP.Response
    #dim %request As %CSP.Request
    #dim %session As %CSP.Session
    
    Do %response.SetHeader("Access-Control-Allow-Origin","*")
    Do %response.SetHeader("Access-Control-Allow-Credentials","true")
    Do %response.SetHeader("Access-Control-Allow-Methods","GET, PUT, POST, DELETE, OPTIONS")
    Do %response.SetHeader("Access-Control-Max-Age","10000")
    Do %response.SetHeader("Access-Control-Allow-Headers","Content-Type, Authorization, Accept-Language, X-Requested-With") 
    
    Set %response.CharSet = "utf-8"
    Set %response.ContentType="application/json"

    Set %session.Language=$$MatchLanguage^%occMessages(%request.GetCgiEnv("HTTP_ACCEPT_LANGUAGE"),"%CSP","+s") // Localization support
    Set %response.Language=%session.Language   
    
    quit $$$OK
}

ClassMethod connect() As %Status
{
    do ..head()
    set ns = %request.Get("NS")
    set classList = %request.Get("classList")
    if ('##class(%SYS.Namespace).Exists($get(ns))) {
        write "{""error"":""Namespace '" _ $get(ns) _ "' does not exists.""}"
        quit $$$OK
    }
    do ##class(ClassList).WriteJSON(ns, $get(classList))
    quit $$$OK
}

ClassMethod open() As %Status
{
    do ..head()
    set ns = %request.Get("NS")
    set className = %request.Get("className")
    set id = %request.Get("id")
    if ('##class(%SYS.Namespace).Exists($get(ns))) {
        write "{""error"":""Namespace '" _ $get(ns) _ "' does not exists.""}"
        quit $$$OK
    }
    do ##class(ClassList).open(ns, $get(className), $get(id))
    quit $$$OK
}

ClassMethod save() As %Status
{
    do ..head()
    set ns = %request.Get("NS")
    set JSON = %request.Get("object")
    if ('##class(%SYS.Namespace).Exists($get(ns))) {
        write "{""error"":""Namespace '" _ $get(ns) _ "' does not exists.""}"
        quit $$$OK
    }
    do ##class(ClassList).save(ns, $get(JSON))
    quit $$$OK
}

ClassMethod query() As %Status
{
    do ..head()
    set ns = %request.Get("NS")
    set className = %request.Get("className")
    set where = %request.Get("where")
    set order = %request.Get("order")
    set aggr = %request.Get("aggr")
    if ('##class(%SYS.Namespace).Exists($get(ns))) {
        write "{""error"":""Namespace '" _ $get(ns) _ "' does not exists.""}"
        quit $$$OK
    }
    do ##class(ClassList).query(ns, $get(className), $get(where), $get(order), $get(aggr))
    quit $$$OK
}

ClassMethod exec() As %Status
{
    do ..head()
    set ns = %request.Get("NS")
    set className = %request.Get("className")
    set methodName = %request.Get("method")
    set params = %request.Get("params")
    set id = %request.Get("id")
    if ('##class(%SYS.Namespace).Exists($get(ns))) {
        write "{""error"":""Namespace '" _ $get(ns) _ "' does not exists.""}"
        quit $$$OK
    }
    do ##class(ClassList).exec(ns, $get(className), $get(methodName), $get(id), params)
    quit $$$OK
}

}
