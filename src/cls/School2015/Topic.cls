/// Hackaton topic description
Class School2015.Topic Extends (%Persistent, %Populate)
{

Property Name As %String(MAXLEN = 100, POPSPEC = "##class(School2015.PopulateHelper).GenProjectName()");

Property Group As School2015.Group;

Property Technologies As list Of %String(POPSPEC = "##class(School2015.PopulateHelper).GenTechnologie():3");

Query QueryAllTopics() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT %ID,
       Name,
       "Group"->Leader->Name||' '||"Group"->Leader->Surname Leader,
       "Group"->Points 
  FROM School2015.Topic
 ORDER BY Name
}

Storage Default
{
<Data name="TopicDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Group</Value>
</Value>
<Value name="4">
<Value>Technologies</Value>
</Value>
</Data>
<DataLocation>^School2015.TopicD</DataLocation>
<DefaultData>TopicDefaultData</DefaultData>
<ExtentSize>10</ExtentSize>
<IdLocation>^School2015.TopicD</IdLocation>
<IndexLocation>^School2015.TopicI</IndexLocation>
<Property name="%%CLASSNAME">
<AverageFieldSize>1</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="%%ID">
<AverageFieldSize>1.1</AverageFieldSize>
<Selectivity>1</Selectivity>
</Property>
<Property name="Group">
<AverageFieldSize>1.6</AverageFieldSize>
<Selectivity>11.1111%</Selectivity>
</Property>
<Property name="Name">
<AverageFieldSize>44</AverageFieldSize>
<Selectivity>12.5000%</Selectivity>
</Property>
<Property name="Technologies">
<AverageFieldSize>14.7</AverageFieldSize>
<Selectivity>11.1111%</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-4</BlockCount>
</SQLMap>
<StreamLocation>^School2015.TopicS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
