/// Participan't description
Class School2015.Participant Extends School2015.Human
{

Property Company As School2015.Company;

Relationship Group As School2015.Group [ Cardinality = one, Inverse = Participants ];

Index GroupIndex On Group;

/*Method OnPopulate() As %Status [ ServerOnly = 1 ]
{
	do ..Contacts.Clear()
	set userName = $translate($extract(..Name, 1)_..Surname, " '.")
	do ..Contacts.SetAt(userName, ##class(School2015.PopulateHelper).GenContactType(1))
	set companyName = $translate(..Company.Name, " .'")
	do ..Contacts.SetAt(userName_"@"_companyName_".com", ##class(School2015.PopulateHelper).GenContactType(2))
	set phone = ##class(%Library.PopulateUtils).USPhone()
	do ..Contacts.SetAt(phone, ##class(School2015.PopulateHelper).GenContactType(3))
	quit $$$OK
}
*/
Storage Default
{
<Data name="ParticipantDefaultData">
<Subscript>"Participant"</Subscript>
<Value name="1">
<Value>Company</Value>
</Value>
<Value name="2">
<Value>Group</Value>
</Value>
<Value name="3">
<Value>Carma</Value>
</Value>
</Data>
<DefaultData>ParticipantDefaultData</DefaultData>
<ExtentSize>150</ExtentSize>
<Property name="%%CLASSNAME">
<AverageFieldSize>24</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="%%ID">
<AverageFieldSize>2.28</AverageFieldSize>
<Selectivity>1</Selectivity>
</Property>
<Property name="Company">
<AverageFieldSize>28.23,Country:6.68,Name:17.55</AverageFieldSize>
<Selectivity>0.6667%,Country:33.3333%,Name:0.6757%</Selectivity>
</Property>
<Property name="Group">
<AverageFieldSize>1.23</AverageFieldSize>
<OutlierSelectivity>.333333:</OutlierSelectivity>
<Selectivity>1.5152%</Selectivity>
</Property>
<Property name="Name">
<AverageFieldSize>5.3</AverageFieldSize>
<Selectivity>1.0753%</Selectivity>
</Property>
<Property name="Surname">
<AverageFieldSize>6.19</AverageFieldSize>
<Selectivity>0.9709%</Selectivity>
</Property>
<SQLMap name="GroupIndex">
<BlockCount>-4</BlockCount>
</SQLMap>
<Type>%Library.CacheStorage</Type>
}

Property Carma As %Integer;

}
