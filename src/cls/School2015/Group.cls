/// Hackaton group's description
Class School2015.Group Extends (%Persistent, %Populate)
{

Relationship Participants As School2015.Participant [ Cardinality = many, Inverse = Group ];

Property Leader As School2015.Participant;

Property Points As %Integer(MINVAL = 0, POPSPEC = "##class(School2015.PopulateHelper).GenStartingPoints()");

Method PrintInfo() As %Status
{
    write "{""Leader"":"""_..Leader.Name_" "_..Leader.Surname_"""}"
    //write "{""Participants"":", !
    //for i=1:1:..Participants.Count()
    //{
    //    write ..Participants.GetAt(i).Name_" "_..Participants.GetAt(i).Surname, !
    //}
    Quit $$$OK
}

ClassMethod AddPoints(ID As %String, point As %Integer = 1) As %Status [ SqlProc ]
{
    set obj = ##class(School2015.Group).%OpenId(ID)
    if ('obj) {
        quit $$$ERROR("No such object")
    } else {
        set obj.Points = obj.Points + point
        set sc = obj.%Save()
        if $$$ISERR(sc) {
                write "{""status"":""ERROR""}"
                quit $$$ERROR($System.Error.FromException(sc))
        } else 
        {
            write "{""status"":""OK""}"
            quit $$$OK
            }
    }
}

Storage Default
{
<Data name="GroupDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Leader</Value>
</Value>
<Value name="3">
<Value>Points</Value>
</Value>
</Data>
<DataLocation>^School2015.GroupD</DataLocation>
<DefaultData>GroupDefaultData</DefaultData>
<ExtentSize>50</ExtentSize>
<IdLocation>^School2015.GroupD</IdLocation>
<IndexLocation>^School2015.GroupI</IndexLocation>
<Property name="%%CLASSNAME">
<AverageFieldSize>1</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="%%ID">
<AverageFieldSize>1.82</AverageFieldSize>
<Selectivity>1</Selectivity>
</Property>
<Property name="Leader">
<AverageFieldSize>1.78</AverageFieldSize>
<Selectivity>3.2258%</Selectivity>
</Property>
<Property name="PartCount">
<AverageFieldSize>1</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="Points">
<AverageFieldSize>1</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-4</BlockCount>
</SQLMap>
<StreamLocation>^School2015.GroupS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

Property PartCount As %Integer [ Calculated, SqlComputeCode = {set {PartCount} = ##class(School2015.Group).CalcPartCount({ID})}, SqlComputed ];

Method PartCountGet() As %Integer [ ServerOnly = 1 ]
{
    Quit ##class(School2015.Group).CalcPartCount(..%Id())
}

ClassMethod CalcPartCount(ID As %Integer) As %Integer
{
    set obj = ##class(School2015.Group).%OpenId(ID)
    quit obj.Participants.Count()
}

}
