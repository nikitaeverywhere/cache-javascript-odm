Class CacheJavaScriptODM.AbstractREST Extends %CSP.REST
{

Parameter UseSession As Integer = 1;

/// Dispatch a REST request according to URL and Method.<br>
/// Add param Namespace to a request to execute MDX in desired namespace.
ClassMethod DispatchRequest(pUrl As %String, pMethod As %String) As %Status [ Internal ]
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
    
    Quit tSC
}

}
