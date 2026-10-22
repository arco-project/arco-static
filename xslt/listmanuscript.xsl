<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    version="2.0"
    exclude-result-prefixes="xsl tei xs">
    
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>
    <xsl:import href="./partials/entities.xsl"/>
    <xsl:import href="./partials/blockquote.xsl"/>
    <xsl:import href="./partials/zotero.xsl"/>
    <xsl:import href="./partials/datatables_import.xsl"/>
    <xsl:output encoding="UTF-8" media-type="text/html" method="html" version="5.0" indent="yes" omit-xml-declaration="yes"/>


    <xsl:template match="/">
        <xsl:variable name="doc_title">
            <xsl:value-of select=".//tei:titleStmt/tei:title[@level='a']/text()"/>
        </xsl:variable>
        <xsl:variable name="link" select="'listmanuscript.html'"/>
        <html class="h-100" lang="{$default_lang}">
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$doc_title"></xsl:with-param>
                </xsl:call-template>
                <xsl:call-template name="zoterMetaTags">
                    <xsl:with-param name="pageId" select="$link"></xsl:with-param>
                    <xsl:with-param name="zoteroTitle" select="$doc_title"></xsl:with-param>
                </xsl:call-template>
                <xsl:call-template name="datatables_import"/>
            </head>
            
            <body class="d-flex flex-column h-100">
                <xsl:call-template name="nav_bar"/>

                <main id="main" tabindex="-1" class="flex-shrink-0 flex-grow-1">   
                    <nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb" class="ps-5 p-3">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item">
                                <a href="index.html">
                                    <xsl:value-of select="$project_short_title"/>
                                </a>
                            </li>
                            <li class="breadcrumb-item active" aria-current="page">
                                <xsl:value-of select="$doc_title"/>
                            </li>
                        </ol>
                    </nav>                 
                    <div class="container">                        
                        <h1>
                            <xsl:value-of select="$doc_title"/>
                        </h1>
                        <div id="custom-info-box" class="text-muted small text-center"></div>
                        
                        <table id="myTable" class="table table-striped">
                            <thead>
                                <tr>
                                    <th scope="col">Title</th>
                                    <th scope="col" data-dt-visible="false">Country</th>
                                    <th scope="col" data-dt-visible="false">Settlement</th>
                                    <th scope="col" data-dt-visible="false">Repository</th>
                                    <th scope="col">Shelfmark</th>
                                    <th scrope="col">Date</th>
                                    <th scrope="col">Place of origin</th>
                                    <th scope="col" data-dt-visible="false">ID</th>
                                </tr>
                            </thead>
                            <tbody>
                                <xsl:for-each select=".//tei:body//tei:msDesc[@xml:id]">
                                    <xsl:variable name="id">
                                        <xsl:value-of select="data(@xml:id)"/>
                                    </xsl:variable>
                                    <tr>
                                        <td>
                                            <a href="{$id||'.html'}">
                                                <xsl:value-of select="./tei:head[1]"/>
                                                
                                            </a>
                                        </td>
                                        <td>
                                            <xsl:value-of select="./tei:msIdentifier[1]/tei:country"/>
                                        </td>
                                        <td>
                                            <xsl:value-of select="./tei:msIdentifier[1]/tei:settlement"/>
                                        </td>
                                        <td>
                                            <xsl:value-of select="./tei:msIdentifier[1]/tei:repository"/>
                                        </td>
                                        <td>
                                            <xsl:value-of select="./tei:msIdentifier[1]/tei:idno[@type='shelfmark']"/>
                                        </td>
                                        <td>
                                            <xsl:value-of select=".//tei:origDate[@when][1]"/>
                                        </td>
                                        <td>
                                            <xsl:value-of select=".//tei:origPlace/tei:placeName[1]"/>
                                        </td>
                                        <td>
                                            <xsl:value-of select="$id"/>
                                        </td>
                                    </tr>
                                </xsl:for-each>
                            </tbody>
                        </table>

                        <div class="text-center p-4">
                            <xsl:call-template name="blockquote">
                                <xsl:with-param name="pageId" select="'listmanuscript.html'"/>
                            </xsl:call-template>
                        </div>
                    </div>
                </main>
                <xsl:call-template name="html_footer"/>
                <script src="js/datatables_custom/datatables_custom.js"></script>
            </body>
        </html>
        <xsl:for-each select=".//tei:body//tei:msDesc[@xml:id]">
            <xsl:variable name="filename" select="concat(./@xml:id, '.html')"/>
            <xsl:variable name="name" select="./tei:head[1]"></xsl:variable>
            <xsl:result-document href="{$filename}">
                <html class="h-100" lang="{$default_lang}">
                    <head>
                        <xsl:call-template name="html_head">
                            <xsl:with-param name="html_title" select="$name"></xsl:with-param>
                        </xsl:call-template>
                        <xsl:call-template name="zoterMetaTags">
                            <xsl:with-param name="pageId" select="$filename"></xsl:with-param>
                            <xsl:with-param name="zoteroTitle" select="$name"></xsl:with-param>
                        </xsl:call-template>
                        <link rel="stylesheet" href="css/editions-toc.css" type="text/css"></link>
                    </head>

                    <body class="d-flex flex-column h-100" data-bs-spy="scroll" data-bs-target="#toc">
                        <xsl:call-template name="nav_bar"/>
                        <main id="main" tabindex="-1" class="flex-shrink-0 flex-grow-1">
                            <nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb" class="ps-5 p-3">
                                <ol class="breadcrumb">
                                    <li class="breadcrumb-item">
                                        <a href="index.html"><xsl:value-of select="$project_short_title"/></a>
                                    </li>
                                    <li class="breadcrumb-item">
                                        <a href="listmanuscript.html"><xsl:value-of select="$doc_title"/></a>
                                    </li>
                                </ol>
                            </nav>
                            <div class="container">
                                <h1>
                                    <xsl:value-of select="$name"/>
                                </h1>
                                <div class="row" id="siteBody">
                                    <div class="col-md-2">
                                        <nav
                                            id="toc"
                                            class="js-toc sticky-top d-none d-md-block"
                                            style="max-height: calc(100vh - 2rem); overflow-y: auto;"
                                            aria-label="Page navigation"
                                            >
                                            <ul class="nav flex-column">
                                                <li class="nav-item">
                                                    <a class="nav-link" href="#info">Info</a>
                                                    <a class="nav-link" href="#contents">Contents</a>
                                                    <a class="nav-link" href="#physical-description">Physical Description</a>
                                                </li>
                                            </ul>
                                        </nav>
                                    </div>
                                    <div class="col-md-10">
                                        <h2 id="info">Info</h2>
                                        
                                        <dl>
                                            <dt>Title</dt>
                                            <dd>
                                                <xsl:value-of select="./tei:head[1]"/>
                                            </dd>
                                            
                                            <dt>Place</dt>
                                            <dd>
                                                <xsl:value-of select="./tei:msIdentifier[1]/tei:settlement"/>
                                            </dd>
                                            
                                            <dt>Repository</dt>
                                            <dd>
                                                <xsl:value-of select="./tei:msIdentifier[1]/tei:repository"/>
                                            </dd>
                                            
                                            <dt>Language</dt>
                                            <dd>
                                                <xsl:value-of select=".//tei:textLang"/>
                                            </dd>
                                        </dl>
                                        
                                        <h2 id="contents">Contents</h2>
                                        <dl>
                                            <dt>Summary</dt>
                                            <dd>
                                                <xsl:apply-templates select=".//tei:summary[1]"></xsl:apply-templates>
                                            </dd>
                                            
                                            <xsl:for-each select=".//tei:msContents/tei:msItem">
                                                <dt>
                                                    <xsl:value-of select="./tei:locus"/>
                                                </dt>
                                                <dd>
                                                    <xsl:value-of select="./tei:title"/>
                                                </dd>
                                            </xsl:for-each>
                                        </dl>
                                        
                                        <h2 id="physical-description">Physical Description</h2>
                                        <dl>
                                            <dt>Material</dt>
                                            <dd>
                                                <xsl:value-of select=".//tei:supportDesc/tei:support"/>
                                            </dd>
                                            
                                            <dt>Extent</dt>
                                            <dd>
                                                <xsl:value-of select=".//tei:supportDesc/tei:extent/text()"/>
                                                <xsl:value-of select=".//tei:supportDesc/tei:extent//tei:height/text()"/>x<xsl:value-of select=".//tei:supportDesc/tei:extent//tei:width/text()"/>
                                            </dd>
                                        </dl>
                                    </div>
                                </div>
                                <div class="text-center p-4">
                                <xsl:call-template name="blockquote">
                                    <xsl:with-param name="pageId" select="$filename"/>
                                </xsl:call-template>
                            </div>
                            </div>
                        </main>
                        <xsl:call-template name="html_footer"/>
                    </body>
                </html>
            </xsl:result-document>
            
        </xsl:for-each>
    </xsl:template>
    
</xsl:stylesheet>