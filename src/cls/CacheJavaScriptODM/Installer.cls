/// Importing this class will enable CJS web application.
Class CacheJavaScriptODM.Installer extends %Projection.AbstractProjection {

Parameter DispatchClass = "CacheJavaScriptODM.REST";

Parameter WebAppName = "/CJS";

Projection Reference As Installer;

ClassMethod RegisterWebApplication(name As %String, spec) As %Status
{
    new $Namespace
    try {
    	set $Namespace = "%SYS"
    } catch (err) {
    	return err
    }
    set st = $$$OK
    if ('##class(Security.Applications).Exists(name)) {
        write !,"Creating WEB application """_name_"""..."
        set st = ##class(Security.Applications).Create(name, .spec)
        write !, "WEB application """_name_""" is created."
    } else { // ensure configuration matches in case of updating from old terminal versions
        write !, "Updating web application """_name_"""..."
        set st = ##class(Security.Applications).Modify(name, .spec)
        write !, "WEB application """_name_""" is updated."
    }
    return st
}

ClassMethod RemoveWebApplication(name As %String)
{
    new $Namespace
    set $Namespace = "%SYS"
    set st = $$$OK
    if (##class(Security.Applications).Exists(name)) {
        do ##class(Security.Applications).Get(name, .props)
        if (props("DispatchClass") '= ..#DispatchClass) && (name = "/terminal") {
            write !, "Won't delete WEB-application """_name_""" because it does not refer to dispatch class anymore."
        } else {
            write !, "Deleting WEB application """_name_"""..."
            set st = ##class(Security.Applications).Delete(name)
            write !, "WEB application """_name_""" was successfully deleted."
        }
    }
    return st
}

/// This method is invoked when a class is compiled.
ClassMethod CreateProjection(cls As %String, ByRef params) As %Status
{
	write !, "Installing CJS application to " _ $namespace
    set cspProperties("AutheEnabled") = $$$AutheUnauthenticated
    set cspProperties("NameSpace") = $namespace
    set cspProperties("Description") = "A WEB application for Cache JavaScript ODM."
    set cspProperties("IsNameSpaceDefault") = $$$NO
    set cspProperties("DispatchClass") = ..#DispatchClass
    return ..RegisterWebApplication(..#WebAppName, .cspProperties)
 }

/// This method is invoked when a class is compiled.
ClassMethod RemoveProjection(cls As %String, ByRef params, recompile As %Boolean) As %Status
{
	write !, "Removing CJS application from " _ $namespace
    return ..RemoveWebApplication(..#WebAppName)
}

}