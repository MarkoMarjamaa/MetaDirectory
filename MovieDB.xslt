<xsl:stylesheet version="2.0"
     xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
     <xsl:template match="/">

<!-- Example of Imdb XML schema 
Kind		/movie/kind
Year		/movie/year
Rating		/movie/rating
Genre		/movie/genres/item
Director	/movie/director/person/name
Actor		/movie/cast/person/name
Writer		/movie/writer/person/name
Languages	/movie/languages/item
Title		/movie/title
-->

	<items>
		<xsl:for-each select="/data/movie">
			<!-- kind/[Rating]/(Rating)/ -->
			<item>
				<xsl:copy-of select="/data/movie/kind/text()"/>/[Rating]/<xsl:copy-of select="/data/movie/rating/text()"/>/<xsl:copy-of select="/data/movie/title/text()"/>
			</item>

			<!-- kind/[Genre]/(Genre)/[Rating]/(Rating) -->
			<xsl:for-each select="/data/movie/genres/item">
				<item>
					<xsl:copy-of select="/data/movie/kind/text()"/>/[Genre]/<xsl:copy-of select="text()"/>/[Rating]/<xsl:copy-of select="/data/movie/rating/text()"/><xsl:text> </xsl:text><xsl:copy-of select="/data/movie/title/text()"/>
				</item>
			</xsl:for-each>

			<!-- kind/[Genre]/(Genre)/(Year)/ -->
			<xsl:for-each select="/data/movie/genres/item">
				<item>
					<xsl:copy-of select="/data/movie/kind/text()"/>/[Genre]/<xsl:copy-of select="text()"/>/<xsl:copy-of select="/data/movie/year/text()"/>/<xsl:copy-of select="/data/movie/title/text()"/>
				</item>
			</xsl:for-each>

			<!-- kind/[Director]/(Director)/ -->
			<xsl:for-each select="/data/movie/director/person">
				<item>
					<xsl:copy-of select="/data/movie/kind/text()"/>/[Director]/<xsl:copy-of select="name/text()"/>/<xsl:copy-of select="/data/movie/title/text()"/>
				</item>
			</xsl:for-each>

			<!-- kind/[Director]/(Director)/[Rating]/(Rating) -->
			<xsl:for-each select="/data/movie/director/person">
				<item>
					<xsl:copy-of select="/data/movie/kind/text()"/>/[Director]/<xsl:copy-of select="name/text()"/>/[Rating]/<xsl:copy-of select="/data/movie/rating/text()"/><xsl:text> </xsl:text><xsl:copy-of select="/data/movie/title/text()"/>
				</item>
			</xsl:for-each>

			<!-- kind/[Director]/(Director)/(Year)/ -->
			<xsl:for-each select="/data/movie/director/person">
				<item>
					<xsl:copy-of select="/data/movie/kind/text()"/>/[Director]/<xsl:copy-of select="name/text()"/>/<xsl:copy-of select="/data/movie/year/text()"/>/<xsl:copy-of select="/data/movie/title/text()"/>
				</item>
			</xsl:for-each>

			<!-- kind/[Actor,All]/(Actor)/ -->
			<xsl:for-each select="/data/movie/cast/person">
				<item>
					<xsl:copy-of select="/data/movie/kind/text()"/>/[Actor, All]/<xsl:copy-of select="substring(name/text(),1,1)"/>/<xsl:copy-of select="name/text()"/>/<xsl:copy-of select="/data/movie/title/text()"/>
				</item>
			</xsl:for-each>

			<!-- kind/[Actor,All]/(Actor)/(Genre)/ -->
			<xsl:for-each select="/data/movie/cast/person">
				<xsl:variable name="actor" select="name/text()"/>
				<xsl:for-each select="/data/movie/genres/item">
					<item>
						<xsl:copy-of select="/data/movie/kind/text()"/>/[Actor, All]/<xsl:copy-of select="substring($actor,1,1)"/>/<xsl:copy-of select="$actor"/>/<xsl:copy-of select="text()"/>/<xsl:copy-of select="/data/movie/title/text()"/>
					</item>
				</xsl:for-each>
			</xsl:for-each>

			<!-- kind/[Actor,All]/(Actor)/(Year)/ -->
			<xsl:for-each select="/data/movie/cast/person">
				<item>
					<xsl:copy-of select="/data/movie/kind/text()"/>/[Actor, All]/<xsl:copy-of select="substring(name/text(),1,1)"/>/<xsl:copy-of select="name/text()"/>/<xsl:copy-of select="/data/movie/year/text()"/>/<xsl:copy-of select="/data/movie/title/text()"/>
				</item>
			</xsl:for-each>

			<!-- kind/[Actor,Top 100]/(Actor)/ -->
			<xsl:for-each select="/data/movie/cast/person">
				<xsl:variable name="actor" select="name/text()"/>
				 <xsl:for-each select="/data/top_actors/actor[name=$actor]">
					<item>
						<xsl:copy-of select="/data/movie/kind/text()"/>/[Actor,Top 100]/<xsl:copy-of select="$actor"/>/<xsl:copy-of select="/data/movie/title/text()"/>
					</item>
				</xsl:for-each>
			</xsl:for-each>

			<!-- kind/[Actor,Top 100]/(Actor)/(Genre)/ -->
			<xsl:for-each select="/data/movie/cast/person">
				<xsl:variable name="actor" select="name/text()"/>
				<xsl:for-each select="/data/top_actors/actor[name=$actor]">
					<xsl:for-each select="/data/movie/genres/item">
						<item>
							<xsl:copy-of select="/data/movie/kind/text()"/>/[Actor,Top 100]/<xsl:copy-of select="$actor"/>/<xsl:copy-of select="text()"/>/<xsl:copy-of select="/data/movie/title/text()"/>
						</item>
					</xsl:for-each>
				</xsl:for-each>
			</xsl:for-each>

			<!-- kind/[Actor,Top 100]/(Actor)/(Year)/ -->
			<xsl:for-each select="/data/movie/cast/person">
				<xsl:variable name="actor" select="name/text()"/>
				 <xsl:for-each select="/data/top_actors/actor[name=$actor]">
					<item>
						<xsl:copy-of select="/data/movie/kind/text()"/>/[Actor,Top 100]/<xsl:copy-of select="$actor"/>/<xsl:copy-of select="/data/movie/year/text()"/>/<xsl:copy-of select="/data/movie/title/text()"/>
					</item>
				</xsl:for-each>
			</xsl:for-each>

			<!-- kind/[Actor,Top 100]/(Actor)/[Rating]/(Rating) -->
			<xsl:for-each select="/data/movie/cast/person">
				<xsl:variable name="actor" select="name/text()"/>
				 <xsl:for-each select="/data/top_actors/actor[name=$actor]">
					<item>
						<xsl:copy-of select="/data/movie/kind/text()"/>/[Actor,Top 100]/<xsl:copy-of select="$actor"/>/[Rating]/<xsl:copy-of select="/data/movie/rating/text()"/><xsl:text> </xsl:text><xsl:copy-of select="/data/movie/title/text()"/>
					</item>
				</xsl:for-each>
			</xsl:for-each>

			<!-- This creates directories for movie title initials -->
			<item>
				<xsl:copy-of select="/data/movie/kind/text()"/>/<xsl:copy-of select="substring(/data/movie/title/text(),1,1)"/>/<xsl:copy-of select="/data/movie/title/text()"/>
			</item>
		</xsl:for-each>
	</items>
     </xsl:template>
 </xsl:stylesheet>