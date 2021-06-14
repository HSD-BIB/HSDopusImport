<?xml version="1.0" encoding="utf-8"?>

<!--/*Transformation in OPUS 4 valides XML
 @author      Stefanie Söhnitz <stefanie.soehnitz@hs-duesseldorf.de>
 @copyright   Hochschulbibliothek Hochschule Düsseldorf, University of Applied Sciences Duesseldorf
 @licence	  https://creativecommons.org/licenses/by/4.0/deed.de
 
 Literaturlisten können aus Citavi exportiert werden - Exportfilter: MODS (Metadata Object Description Schema)
 * entferne alle Attribute aus dem root Element <modsCollection>
 * entstandene Datei als opus.xml benennen und als ZIP (package.zip) packen
 * Datei über SWORD an OPUS 4 senden - Achtung: Dateigröße sollte nicht mehr als 2 KB haben, sonst wird ERROR angezeigt
 *****
 literature collections must be exported with citavi - use the export filter: MODS (Metadata Object Description Schema)
 * remove all attributes from the root element <modsCollection>
 * final XML file must be named opus.xml and packed into a package.zip
 * upload the file via SWORD (e.g. use postman) - attention: filesize shouldn`t be larger than 2KB, otherwise you get an error
 */-->
 
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- <xsl:import href="outputTokens.xsl"/> -->
  <xsl:output method="xml" version="2.0" omit-xml-declaration="yes" indent="yes" encoding="utf-8"/>
 

	<xsl:template match="modsCollection">
		
		<import>
			<xsl:for-each select="mods">
				<opusDocument>
				
				<!--Variable für language - deutsch/englisch -> bei anderen Sprachen müssen diese hier ergaenzt werden
				*****
				Variable for language - German/English -> for other languages these must be added here-->
					<xsl:variable name="lang">
					   	<xsl:choose>
							<xsl:when test="language/languageTerm='eng'">
								<xsl:text>eng</xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>deu</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
			
					<xsl:attribute name="language">
						<xsl:value-of select="$lang"/>
					</xsl:attribute>		
				
					<xsl:attribute name="type">
						<xsl:choose>		
											
							<xsl:when test="genre[contains(@valueURI,'bookPart')]">
								<xsl:text>bookpart</xsl:text>
							</xsl:when>
							<xsl:when test="genre[contains(@valueURI,'book')]">
								<xsl:text>book</xsl:text>
							</xsl:when>
							<xsl:when test="genre[contains(@valueURI,'article')]">
								<xsl:text>article</xsl:text>
							</xsl:when>
							<xsl:when test="genre[contains(@valueURI,'report')]">
								<xsl:text>report</xsl:text>
							</xsl:when>
							<xsl:when test="genre[contains(@valueURI,'book')]">
								<xsl:text>report</xsl:text>
							</xsl:when>
							
							<xsl:when test="note='Masterarbeit'">
								<xsl:text>masterthesis</xsl:text>
							</xsl:when>
							<xsl:when test="note='Bachelorarbeit'">
								<xsl:text>bachelorthesis</xsl:text>
							</xsl:when>
								<xsl:when test="note='Diplomarbeit'">
								<xsl:text>diplom</xsl:text>
							</xsl:when>
								<xsl:when test="genre[contains(@valueURI,'doctoralThesis')]">
								<xsl:text>doctoralthesis</xsl:text>
							</xsl:when>
							
							<xsl:otherwise>
								<xsl:text>other</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					
					<!--Seitenzahlen / pages-->
					<xsl:if test="string-length(relatedItem/part/extent/list/text()) &gt; 0">  
						<xsl:attribute name="pageNumber">
							<xsl:value-of select="relatedItem/part/extent/list"/>
						</xsl:attribute>
						<xsl:attribute name="pageFirst">
							<xsl:value-of select="substring-before(relatedItem/part/extent/list, '–')"/>
						</xsl:attribute>		
						<xsl:attribute name="pageLast">
							<xsl:value-of select="substring-after(relatedItem/part/extent/list, '–')"/>
						</xsl:attribute>					
					</xsl:if>
					
					<xsl:if test="relatedItem/part/detail[@type='volume']">
						<xsl:attribute name="volume">
						<xsl:value-of select="relatedItem/part/detail[@type='volume']/number"/>
					</xsl:attribute>
					</xsl:if>
					
					<xsl:if test="relatedItem/part/detail[@type='issue']">
						<xsl:attribute name="issue">
							<xsl:value-of select="relatedItem/part/detail[@type='issue']/number"/>
						</xsl:attribute>
					 </xsl:if>
					 
					<xsl:if test="relatedItem/originInfo">
					<xsl:attribute name="publisherPlace">
						<xsl:value-of select="relatedItem/originInfo/place/placeTerm"/>
					</xsl:attribute>
					</xsl:if>
					
					<xsl:if test="relatedItem/originInfo">
						<xsl:attribute name="publisherName">
							<xsl:value-of select="relatedItem/originInfo/publisher"/>
						</xsl:attribute>
					</xsl:if>
							
					<xsl:if test="originInfo">
					<xsl:attribute name="publisherPlace">
						<xsl:value-of select="originInfo/place/placeTerm"/>
					</xsl:attribute>
					</xsl:if>
					
					<xsl:if test="originInfo">
					<xsl:attribute name="publisherName">
						<xsl:value-of select="originInfo/publisher"/>
					</xsl:attribute>
					</xsl:if>
					
					<xsl:if test="originInfo">
					<xsl:attribute name="creatingCorporation">
						<xsl:value-of select="originInfo/publisher"/>
					</xsl:attribute>
					</xsl:if>
					
					<xsl:if test="name[@displayLabel='Institution']">
					<xsl:attribute name="creatingCorporation">
						<xsl:value-of select="name[@displayLabel='Institution']/namePart"/>
					</xsl:attribute>
					</xsl:if>
					
						<xsl:if test="name[@displayLabel='Institution']">
					<xsl:attribute name="publisherName">
						<xsl:value-of select="name[@displayLabel='Institution']/namePart"/>
					</xsl:attribute>
					</xsl:if>
										
					<xsl:attribute name="belongsToBibliography">
						<xsl:text>false</xsl:text>
					</xsl:attribute>
					
					<!--ATTENTION: serviceState muss so eingestellt werden - sonst sind Sie direkt veroeffentlicht
					*****
					serviceState must be set like this - otherwise you are directly published-->
					<xsl:attribute name="serverState">
						<xsl:text>unpublished</xsl:text>
					</xsl:attribute>
	
					<persons>
						<xsl:for-each select="name">
							<xsl:if test="role/roleTerm='aut'">
								<person>
									<xsl:attribute name="role">
									   <xsl:text>author</xsl:text>
									</xsl:attribute>
									<xsl:attribute name="firstName">
										<xsl:value-of select="namePart[@type='given']"/>
									</xsl:attribute>
									<xsl:attribute name="lastName">
										<xsl:value-of select="namePart[@type='family']"/>
									</xsl:attribute>
								</person>
							</xsl:if>
								
							<xsl:if test="role/roleTerm='ths'">
								<person>
									<xsl:attribute name="role">
									   <xsl:text>referee</xsl:text>
									</xsl:attribute>
									<xsl:attribute name="firstName">
										<xsl:value-of select="namePart[@type='given']"/>
									</xsl:attribute>
									<xsl:attribute name="lastName">
										<xsl:value-of select="namePart[@type='family']"/>
									</xsl:attribute>
								</person>
							</xsl:if>
							
							<xsl:if test="role/roleTerm='edt'">
								<person>
									<xsl:attribute name="role">
									   <xsl:text>editor</xsl:text>
									</xsl:attribute>
									<xsl:attribute name="firstName">
										<xsl:value-of select="namePart[@type='given']"/>
									</xsl:attribute>
									<xsl:attribute name="lastName">
										<xsl:value-of select="namePart[@type='family']"/>
									</xsl:attribute>
								</person>
							</xsl:if>
						</xsl:for-each>
						 
						<xsl:for-each select="relatedItem/name">
							<person>
								<xsl:if test="role/roleTerm='edt'">
									<xsl:attribute name="role">
											<xsl:text>editor</xsl:text>
									</xsl:attribute>
									<xsl:attribute name="firstName">
										<xsl:value-of select="namePart[@type='given']"/>
									</xsl:attribute>
									<xsl:attribute name="lastName">
										<xsl:value-of select="namePart[@type='family']"/>
									</xsl:attribute>
								</xsl:if>
							</person>
						 </xsl:for-each>
					</persons>
				
					<dates>
						<xsl:choose>
		
							<xsl:when test="genre[contains(@valueURI,'doctoralThesis')]">
								<date>									
									<xsl:attribute name="type">
										<xsl:text>completed</xsl:text>
									</xsl:attribute>
									<xsl:attribute name="monthDay">
										<xsl:text>-</xsl:text>
										<xsl:value-of select="substring(originInfo/dateIssued, 5, 6)"/>
									</xsl:attribute>
									<xsl:attribute name="year">
										<xsl:value-of select="substring(originInfo/dateIssued, 1, 4)" />
									</xsl:attribute>
								</date>	
													
								<date>
									<xsl:attribute name="type">
										<xsl:text>thesisAccepted</xsl:text>
									</xsl:attribute>
									<xsl:attribute name="year">
										<xsl:value-of select="substring(originInfo/dateIssued, 1, 4)" />
									</xsl:attribute>
								</date>
							</xsl:when>								
								
							<xsl:otherwise>
								<date>
									<xsl:attribute name="type">
										<xsl:text>completed</xsl:text>
									</xsl:attribute>
							
									<xsl:choose>
										<xsl:when test="genre[contains(@valueURI,'article')]">
											<xsl:attribute name="year">
												<xsl:value-of select="relatedItem/part/date"/>
											</xsl:attribute>
										</xsl:when>
										<xsl:when test="genre[contains(@valueURI,'bookPart')]">
											<xsl:attribute name="year">
												<xsl:value-of select="relatedItem/originInfo/dateIssued"/>
											</xsl:attribute>
										</xsl:when>
										<xsl:when test="genre[contains(@valueURI,'report')]">
											<xsl:attribute name="year">
												<xsl:value-of select="originInfo/dateIssued"/>
											</xsl:attribute>
										</xsl:when>
										<xsl:when test="genre[contains(@valueURI,'book')]">
											<xsl:attribute name="year">
												<xsl:value-of select="originInfo/dateIssued"/>
											</xsl:attribute>
										</xsl:when>
										<xsl:when test="genre[contains(@valueURI,'lecture')]">
											<xsl:attribute name="year">
												<xsl:value-of select="substring(originInfo/dateIssued, 1, 4)"/>
											</xsl:attribute>	
										</xsl:when>
										<xsl:when test="genre[contains(@valueURI,'patent')]">
											<xsl:attribute name="year">
												<xsl:value-of select="substring(originInfo/dateIssued, 1, 4)"/>
											</xsl:attribute>	
										</xsl:when>
										<xsl:when test="relatedItem">
											<xsl:attribute name="year">
												<xsl:value-of select="relatedItem/originInfo/dateIssued"/>
											</xsl:attribute>
										</xsl:when>
																	
										<xsl:otherwise>
											<xsl:attribute name="year">
											<xsl:value-of select="originInfo/dateIssued"/>
										</xsl:attribute>	
										</xsl:otherwise>
									</xsl:choose>
															
								</date>
							</xsl:otherwise>
						</xsl:choose>	
					</dates>
					
					<titlesMain>
						<titleMain>
							<xsl:attribute name="language">
								<xsl:value-of select="$lang"/>
							</xsl:attribute>	
							<xsl:value-of select="titleInfo/title"/>					
						</titleMain>	
					</titlesMain>
			
					<xsl:if test="relatedItem/titleInfo">
						<titles>
							<title>
								<xsl:attribute name="language">
										<xsl:value-of select="$lang"/>
									</xsl:attribute>	
									<xsl:attribute name="type"><xsl:text>parent</xsl:text></xsl:attribute> 
								<xsl:value-of select="relatedItem/titleInfo/title"/>		
							</title>
						</titles>	
					</xsl:if>
										
					<xsl:if test="abstract">
						<abstracts>	
							<abstract>
								<xsl:attribute name="language">
									<xsl:value-of select="$lang"/>
								</xsl:attribute>	
								<xsl:value-of select="abstract"/>
							</abstract>
						</abstracts>
					</xsl:if>

					<keywords>
						<xsl:for-each select="subject">
							<keyword>
								<xsl:attribute name="language">
									<xsl:value-of select="$lang"/>
								</xsl:attribute>
								<xsl:attribute name="type"><xsl:text>uncontrolled</xsl:text></xsl:attribute>
								<xsl:value-of select="topic"/>
							</keyword>
						</xsl:for-each>
					</keywords>
					
					<!--Collection ist HSD spezifisch / hier wird es direkt den entsprechenden Fachbereichen zugeordnet
					*****
					Collection is HSD specific / here it is directly assigned to the corresponding departments-->
					__COLLECTIONS__DEFIONTION__
					
					<!-- Lizenzen - wenn es keine gibt wird standardmäßig immer auf "Keine Lizenz - Nur Metadaten gestellt" hingewiesen
					*****
					Licenses - if there are none, the default is always "No license - Only metadata provided"-->
					__LICENCES__DEFINITION__
					
					
					
					<identifiers>
						<xsl:if test="identifier[@type='isbn']">
							<identifier>
								<xsl:attribute name="type"><xsl:text>isbn</xsl:text></xsl:attribute>							
								<xsl:value-of select="identifier[@type='isbn']"/>			
							</identifier>
						</xsl:if>
						
						<xsl:if test="relatedItem/identifier[@type='isbn']">
							<identifier>
								<xsl:attribute name="type"><xsl:text>isbn</xsl:text></xsl:attribute>							
								<xsl:value-of select="relatedItem/identifier[@type='isbn']"/>			
							</identifier>
						</xsl:if>	
												
						<xsl:if test="identifier[@type='urn']">
							<identifier>
								<xsl:attribute name="type"><xsl:text>urn</xsl:text></xsl:attribute>							
								<xsl:value-of select="identifier[@type='urn']"/>			
							</identifier>
						</xsl:if>
						
						<xsl:if test="identifier[@type='doi']">
							<identifier>
								<xsl:attribute name="type"><xsl:text>doi</xsl:text></xsl:attribute>							
								<xsl:value-of select="identifier[@type='doi']"/>			
							</identifier>
						</xsl:if>
					
						<xsl:if test="location/url">
							<identifier>
								<xsl:attribute name="type"><xsl:text>url</xsl:text></xsl:attribute>							
								<xsl:value-of select="location/url"/>			
							</identifier>
						</xsl:if>
					</identifiers>
					
					<xsl:if test="string-length(note[@displayLabel='Notiz']/text()) &gt; 0">
						<notes>
							<note>
								<xsl:attribute name="visibility">
									<xsl:text>public</xsl:text>
								</xsl:attribute>
								<xsl:value-of select="note[@displayLabel='Notiz']"/>
							</note>
						</notes>
					</xsl:if>
	
				
				</opusDocument>				
			</xsl:for-each>
		</import>
	</xsl:template>	

</xsl:stylesheet>
