<?xml version="1.0"?>
<!-- 
Infragistics UltraWebGrid Script 
Version 6.1.20061.28
Copyright (c) 2001-2006 Infragistics, Inc. All Rights Reserved.
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:wbg="http://schemas.infragistics.com/WebGrid" xmlns:lit="http://schemas.infragistics.com/WebGrid/Literal">
<xsl:output omit-xml-declaration="yes" method="html"/>
<xsl:param name="gridName"/>
<xsl:param name="fac"/>
<xsl:param name="rs"/>
<xsl:param name="expAreaClass"/>
<xsl:param name="expandImage"/>
<xsl:param name="rowLabelClass"/>
<xsl:param name="blankImage"/>
<xsl:param name="rowLabelBlankImage"/>
<xsl:param name="itemClass"/>
<xsl:param name="altClass"/>
<xsl:param name="selClass"/>
<xsl:param name="optSelectRow"/>
<xsl:param name="grpClass"/>
<xsl:param name="tableLayout"/>
<xsl:param name="grpWidth"/>
<xsl:param name="parentRowLevel"/>
<xsl:param name="rowHeight"/>
<xsl:param name="rowToStart"/>
<xsl:param name="useFixedHeaders"/>
<xsl:param name="nfspan"/>
<xsl:param name="fixedScrollLeft"/>
<xsl:param name="isXhtml"/>
	
<xsl:key name="columnIndex" match="wbg:Column" use="@index"/>
<xsl:key name="cellIndex" match="wbg:C" use="position()"/>
<xsl:template match="/">
	<xsl:apply-templates select="wbg:Rs" />
</xsl:template>

<xsl:template match="wbg:Rs">
	<table>
		<tbody>
			<xsl:apply-templates select="wbg:R" />
			<xsl:apply-templates select="wbg:Group" />
		</tbody>
	</table>
</xsl:template>

<xsl:template match="wbg:R">
	<xsl:variable name="rowIndex">
		<xsl:value-of select="@i"/>
	</xsl:variable>
	<tr id="{$gridName}_r_{$parentRowLevel}{$rowIndex}" level="{$parentRowLevel}{$rowIndex}">
		<xsl:if test="$optSelectRow">
			<xsl:attribute name="class">
				<xsl:choose>
					<xsl:when test="$rowIndex mod 2 = 1">
						<xsl:value-of select="$altClass" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$itemClass" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
		</xsl:if>
		<xsl:attribute name="style">
			<xsl:if test="@lit:hidden">display:none;</xsl:if>
			<xsl:choose>
				<xsl:when test="@lit:height">
					<xsl:value-of select="concat('height:',@lit:height,';')" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat('height:',$rowHeight,';')" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
		<xsl:if test="$fac>1 or $rs=2 and $fac=1">
			<td class="{$expAreaClass}">
				<xsl:choose>
					<xsl:when test="@showExpand">
						<xsl:value-of select="$expandImage" disable-output-escaping="yes" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$blankImage" disable-output-escaping="yes" />
					</xsl:otherwise>
				</xsl:choose>
			</td>
		</xsl:if>
		<xsl:if test="$fac>0 and $rs!=2">
		<td id="{$gridName}_l_{$parentRowLevel}{$rowIndex}" class="{$rowLabelClass}" style="text-align:center;vertical-align:middle;">
				<xsl:choose>
					<xsl:when test="@lit:rowNumber">
						<xsl:value-of select="@lit:rowNumber" disable-output-escaping="yes" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$rowLabelBlankImage"  disable-output-escaping="yes" />
					</xsl:otherwise>
				</xsl:choose>
			</td>
		</xsl:if>
		<xsl:apply-templates select="wbg:Cs">
			<xsl:with-param name="rowIndex">
				<xsl:value-of select="$rowIndex" />
			</xsl:with-param>
			<xsl:with-param name="row" select="." />
			<xsl:with-param name="rowHeight" >
				<xsl:choose>
					<xsl:when test="@lit:height">
						<xsl:value-of select="@lit:height" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$rowHeight" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
		</xsl:apply-templates>
	</tr>
</xsl:template>
<xsl:template match="wbg:Cs">
	<xsl:param name="rowIndex" />
	<xsl:param name="row" />
	<xsl:param name="rowHeight" />
	<xsl:for-each select="../../wbg:Columns/wbg:Column">
		<xsl:if test="not(@grouped) and not(@serverOnly) and not(@nonfixed)">
			<xsl:variable name="columnIndex">
				<xsl:value-of select="@cellIndex"/>
			</xsl:variable>
			<xsl:variable name="cell" select="$row/wbg:Cs/wbg:C[number($columnIndex)]"/>
			<xsl:choose>
				<xsl:when test="$rowIndex mod 2 = 1">
					<xsl:call-template name="cellTemplate">
						<xsl:with-param name="cell" select="$cell" />
						<xsl:with-param name="rowIndex">
							<xsl:value-of select="$rowIndex" />
						</xsl:with-param>
						<xsl:with-param name="className">
							<xsl:if test="not($optSelectRow)">
								<xsl:value-of select="$altClass" />
							</xsl:if>
						</xsl:with-param>
						<xsl:with-param name="rowHeight" select="$rowHeight" />
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="cellTemplate">
						<xsl:with-param name="cell" select="$cell" />
						<xsl:with-param name="rowIndex">
							<xsl:value-of select="$rowIndex" />
						</xsl:with-param>
						<xsl:with-param name="className">
							<xsl:if test="not($optSelectRow)">
								<xsl:value-of select="$itemClass" />
							</xsl:if>
						</xsl:with-param>
						<xsl:with-param name="rowHeight" select="$rowHeight" />
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:for-each>

	<xsl:if test="$useFixedHeaders">
		<td colspan="{$nfspan}">
			<xsl:choose>
				<xsl:when test="$optSelectRow">
					<xsl:attribute name="class">
						<xsl:value-of select="concat($gridName,'-no')" />
					</xsl:attribute>
					<xsl:if test="$row/@lit:dtdh">
						<xsl:attribute name="height">
							<xsl:value-of select="$row/@lit:dtdh" />
						</xsl:attribute>
					</xsl:if>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="style">
						<xsl:choose>
							<xsl:when test="$row/@lit:dtdh">
								<xsl:value-of select="concat('vertical-align:top;height:',$row/@lit:dtdh,';')" />
							</xsl:when>
							<xsl:otherwise>vertical-align:top;width:100%;</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
			<div id="{$gridName}_drs">
				<xsl:attribute name="style">
					<xsl:choose>
						<xsl:when test="$row/@lit:dtdh">overflow:hidden;height:100%;<xsl:if test="$isXhtml">position:relative;</xsl:if></xsl:when>
						<xsl:otherwise>overflow:hidden;width:100%;height:100%;<xsl:if test="$isXhtml">position:relative;</xsl:if></xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<table border="0" cellspacing="0" cellpadding="0" style="position:relative;table-layout:fixed;{$fixedScrollLeft}" height="100%">
					<colgroup>
						<xsl:for-each select="../../wbg:Columns/wbg:Column">
							<xsl:if test="not(@grouped) and not(@serverOnly) and not(@hidden) and @nonfixed">
								<col width="{@lit:width}"/>
							</xsl:if>
						</xsl:for-each>
						<xsl:for-each select="../../wbg:Columns/wbg:Column">
							<xsl:if test="not(@grouped) and not(@serverOnly) and @hidden and @nonfixed">
								<col width="1px" style="display:none;"/>
							</xsl:if>
						</xsl:for-each>
					</colgroup>
						<tr id="{$gridName}_nfr_{$parentRowLevel}{$rowIndex}">
						<xsl:attribute name="style">
							<xsl:choose>
								<xsl:when test="$row/@lit:height">
									<xsl:value-of select="concat('height:',$row/@lit:height,';')" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="concat('height:',$rowHeight,';')" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
						<xsl:for-each select="../../wbg:Columns/wbg:Column">
							<xsl:variable name="columnIndex">
								<xsl:value-of select="@cellIndex"/>
							</xsl:variable>
							<xsl:variable name="cell" select="$row/wbg:Cs/wbg:C[number($columnIndex)]"/>
							<xsl:if test="not(@grouped) and not(@serverOnly) and @nonfixed">
								<xsl:choose>
									<xsl:when test="$rowIndex mod 2 = 1">
										<xsl:call-template name="cellTemplate">
											<xsl:with-param name="cell" select="$cell" />
											<xsl:with-param name="rowIndex">
												<xsl:value-of select="$rowIndex" />
											</xsl:with-param>
											<xsl:with-param name="className">
												<xsl:if test="not($optSelectRow)">
													<xsl:value-of select="$altClass" />
												</xsl:if>
											</xsl:with-param>
											<xsl:with-param name="rowHeight" select="$rowHeight" />
										</xsl:call-template>
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="cellTemplate">
											<xsl:with-param name="cell" select="$cell" />
											<xsl:with-param name="rowIndex">
												<xsl:value-of select="$rowIndex" />
											</xsl:with-param>
											<xsl:with-param name="className">
												<xsl:if test="not($optSelectRow)">
													<xsl:value-of select="$itemClass" />
												</xsl:if>
											</xsl:with-param>
											<xsl:with-param name="rowHeight" select="$rowHeight" />
										</xsl:call-template>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:if>
						</xsl:for-each>
					</tr>
				</table>
			</div>
		</td>
	</xsl:if>
	
		
	
</xsl:template>

<xsl:template name="cellTemplate">
	<xsl:param name="cell" />
	<xsl:param name="rowIndex" />
	<xsl:param name="className" />
	<xsl:param name="rowHeight" />
	<xsl:variable name="cellIndex">
		<xsl:value-of select="position()-1"/>
	</xsl:variable>
	<td id="{$gridName}_rc_{$parentRowLevel}{$rowIndex}_{$cellIndex}">
		<xsl:if test="$cell/@title">
			<xsl:attribute name="title">
				<xsl:value-of select="$cell/@title" />
			</xsl:attribute>
		</xsl:if>
		<xsl:if test="$className or ./@class or $cell/@class">
			<xsl:attribute name="class">
				<xsl:value-of select="concat($className,' ',./@class,' ',$cell/@class)" />
			</xsl:attribute>
		</xsl:if>
		<xsl:if test="./@style or $cell/@style or ./@hidden">
			<xsl:attribute name="style">
				<xsl:value-of select="concat(./@style,$cell/@style)" />
				<xsl:if test="./@hidden">display:none;</xsl:if>
			</xsl:attribute>
		</xsl:if>
		<xsl:if test="$cell/@allowedit">
			<xsl:attribute name="allowedit">
				<xsl:value-of select="$cell/@allowedit" />
			</xsl:attribute>
		</xsl:if>
		<xsl:if test="$cell/@uV">
			<xsl:attribute name="uV">
				<xsl:value-of select="$cell/@uV" />
			</xsl:attribute>
		</xsl:if>
		<xsl:if test="$cell/@iCT">
			<xsl:attribute name="iCT">
				<xsl:value-of select="$cell/@iCT" />
			</xsl:attribute>
		</xsl:if>
		<xsl:if test="$cell/@iDV">
			<xsl:attribute name="iDV">
				<xsl:value-of select="$cell/@iDV" />
			</xsl:attribute>
		</xsl:if>
		<xsl:value-of select="$cell/wbg:Ct" disable-output-escaping="yes" />
	</td>
</xsl:template>

<xsl:template match="wbg:Group">
	<xsl:variable name="rowIndex">
		<xsl:value-of select="@i"/>
	</xsl:variable>
	<tr id="{$gridName}_gr_{$parentRowLevel}{$rowIndex}" groupRow="{@lit:groupRow}" level="{$parentRowLevel}{$rowIndex}">
		<xsl:attribute name="style">height:<xsl:value-of select="$rowHeight" />;<xsl:if test="$isXhtml and $useFixedHeaders">position:relative;</xsl:if></xsl:attribute>
		<td>
			<table height='100%' border='0' cellpadding='0' cellspacing='0' bgcolor='{@lit:bgcolor}' bandNo='{@lit:bandNo}'>
				<xsl:if test="$tableLayout">
					<xsl:attribute name="style">table-layout:fixed;</xsl:attribute>
				</xsl:if>
				<xsl:attribute name="width"><xsl:value-of select="$grpWidth" disable-output-escaping="yes" /></xsl:attribute>
				<tr id="{$gridName}_sgr_{$parentRowLevel}{$rowIndex}" level="{$parentRowLevel}{$rowIndex}" groupRow="{@lit:groupRow}">
					<td id="{$gridName}_grc_{$parentRowLevel}{$rowIndex}" groupRow="{@lit:groupRow}" class='{$grpClass}'>
					
						<xsl:attribute name="cellValue">
							<xsl:value-of select="wbg:V" disable-output-escaping="yes" />
						</xsl:attribute>
						<xsl:value-of select="$expandImage" disable-output-escaping="yes" />
						<xsl:value-of select="wbg:Ct" disable-output-escaping="yes" />
					</td>
				</tr>
			</table>
		</td>
	</tr>
</xsl:template>

</xsl:stylesheet>
