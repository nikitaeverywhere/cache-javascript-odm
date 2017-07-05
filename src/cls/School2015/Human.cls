/// Human descriprion
Class School2015.Human Extends (%Persistent, %Populate)
{

Property Name As %String(POPSPEC = "FirstName()");

Property Surname As %String(MAXLEN = 100, POPSPEC = "LastName()");

// Property Contacts As array Of %String;

/*Query QueryHumanContacts(ID As %String) As %Query(ROWSPEC = "Type:%String:Type,Value:%String:Value") [ SqlProc ]
{
}

ClassMethod QueryHumanContactsExecute(ByRef qHandle As %Binary, ID As %String) As %Status
{
   set human = ##class(School2015.Human).%OpenId(ID) 
   if '$IsObject(human) quit $$$ERROR() 
   Set key = "" 
   Do { 
      Set email = human.Contacts.GetNext(.key) 
      If (email '= "") { 
         set $li(qHandle, *+1) = $lb(key, email) 
      } 
   } While (key '= "") 
   kill ^||iter 
   set ^||iter = 1 
   Quit $$$OK
}

ClassMethod QueryHumanContactsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryHumanContactsExecute ]
{
	Quit $$$OK
}

ClassMethod QueryHumanContactsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryHumanContactsExecute ]
{
   set rs=$get(qHandle) 
   if $ll(rs)=0 { 
      set Row="" 
      set AtEnd=1 
      quit $$$OK 
   } 
   if ^||iter <= $ll(rs) { 
      set Row=$li(rs, ^||iter) 
      set AtEnd=0 
      set ^||iter = $increment(^||iter) 
   } else { 
      set Row="" 
      set AtEnd=1 
   } 
   Quit $$$OK
}*/
Storage Default
{
<Data name="Contacts">
<Attribute>Contacts</Attribute>
<Structure>subnode</Structure>
<Subscript>"Contacts"</Subscript>
</Data>
<Data name="HumanDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Surname</Value>
</Value>
</Data>
<DataLocation>^School2015.HumanD</DataLocation>
<DefaultData>HumanDefaultData</DefaultData>
<IdLocation>^School2015.HumanD</IdLocation>
<IndexLocation>^School2015.HumanI</IndexLocation>
<StreamLocation>^School2015.HumanS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
