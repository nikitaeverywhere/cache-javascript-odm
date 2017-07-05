/// Participant's company's description
Class School2015.Company Extends (%SerialObject, %Populate)
{

Property Name As %String(MAXLEN = 100, POPSPEC = "Company()");

Property Country As %String(POPSPEC = "##class(School2015.PopulateHelper).GenCountry()");

Storage Default
{
<Data name="CompanyState">
<Value name="1">
<Value>Name</Value>
</Value>
<Value name="2">
<Value>Country</Value>
</Value>
</Data>
<State>CompanyState</State>
<StreamLocation>^School2015.CompanyS</StreamLocation>
<Type>%Library.CacheSerialState</Type>
}

}
