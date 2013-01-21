CREATE TABLE [dbo].[friends](
	[friendID] [int] IDENTITY(1,1) NOT NULL,
	[firstname] [varchar](50) NOT NULL,
	[lastname] [varchar](50) NOT NULL,
 CONSTRAINT [PK_friends] PRIMARY KEY CLUSTERED 
(
	[friendID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, 
	IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, 
	ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

CREATE XML SCHEMA COLLECTION friendCollection AS
'<?xml version="1.0" encoding="utf-8"?>
<xs:schema id="friends" xmlns="" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:msdata="urn:schemas-microsoft-com:xml-msdata">
  <xs:element name="friends" msdata:IsDataSet="true" msdata:Locale="en-US">
    <xs:complexType>
      <xs:choice minOccurs="0" maxOccurs="unbounded">
        <xs:element name="friend">
          <xs:complexType>
            <xs:attribute name="firstname" type="xs:string" />
            <xs:attribute name="lastname" type="xs:string" />
          </xs:complexType>
        </xs:element>
      </xs:choice>
    </xs:complexType>
  </xs:element>
</xs:schema>'

GO

CREATE PROCEDURE [dbo].[addFriends]
	@friends XML(friendCollection)
AS
BEGIN
	INSERT INTO friends(firstname, lastname)
	SELECT item.value('@firstname', 'varchar(50)') firstname, 
			item.value('@lastname', 'varchar(50)') lastname
	FROM @friends.nodes('//friend') t (item)	
END