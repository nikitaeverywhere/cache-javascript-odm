/// Helper to populate objects
Class School2015.PopulateHelper
{

ClassMethod GenContactType(type As %Integer) As %String
{
 set l = $lb("Scype", "Mail", "Phone")
 quit $li(l, type)
}

ClassMethod GenStartingPoints() As %Integer
{
	quit 0
}

ClassMethod GenCountry() As %String
{
	set l = $lb("Russia", "Belorus", "Ukraine")
	quit $li(l, $r($ll(l))+1)
}

ClassMethod GenTechnologie() As %String
{
	set l = $lb("REST", "Angular.JS", "Cache", "Ensamble", "JSON", 
	            "React.JS", "DeepSee", "iKnow", "SQL", "Indices")
	quit $li(l, $r($ll(l))+1)
}

ClassMethod GenProjectName() As %String
{
   set topic = ##class(%Library.PopulateUtils).Mission()
   set topic = $extract(topic, 1, 50)
   SET position=$LENGTH(topic)-$FIND($REVERSE(topic)," ")
   quit $extract(topic, 1, position+1)
}

ClassMethod PopulateData()
{
	do ##class(School2015.Human).%KillExtent()
	do ##class(School2015.Group).%KillExtent()
	do ##class(School2015.Topic).%KillExtent()
	
	set m = 10	
	do ##class(School2015.Participant).Populate(5*m)
	do ##class(School2015.Group).Populate(5*m)
	do ##class(School2015.Participant).Populate(10*m)	
	do ##class(School2015.Topic).Populate(m)
}

}
