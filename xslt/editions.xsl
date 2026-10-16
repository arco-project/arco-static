<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    version="2.0"
    exclude-result-prefixes="xsl tei xs">
    
    <xsl:import href="./partials/shared.xsl"/>
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>
    <xsl:import href="./partials/blockquote.xsl"/>
    <xsl:import href="./partials/zotero.xsl"/>
    <xsl:output encoding="UTF-8" media-type="text/html" method="html" version="5.0" indent="yes" omit-xml-declaration="yes"/>

    <xsl:variable name="prev">
        <xsl:value-of select="replace(tokenize(data(tei:TEI/@prev), '/')[last()], '.xml', '.html')"/>
    </xsl:variable>
    <xsl:variable name="next">
        <xsl:value-of select="replace(tokenize(data(tei:TEI/@next), '/')[last()], '.xml', '.html')"/>
    </xsl:variable>
    <xsl:variable name="teiSource">
        <xsl:value-of select="data(tei:TEI/@xml:id)"/>
    </xsl:variable>
    <xsl:variable name="link">
        <xsl:value-of select="replace($teiSource, '.xml', '.html')"/>
    </xsl:variable>
    <xsl:variable name="doc_title">
        <xsl:value-of select=".//tei:titleStmt/tei:title[1]/text()"/>
    </xsl:variable>


    <xsl:template match="/">
        <html class="h-100" lang="{$default_lang}">
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$doc_title"></xsl:with-param>
                </xsl:call-template>
                <xsl:call-template name="zoterMetaTags">
                    <xsl:with-param name="pageId" select="$link"></xsl:with-param>
                    <xsl:with-param name="zoteroTitle" select="$doc_title"></xsl:with-param>
                </xsl:call-template>
                <!-- Provide the names of the authors/editors of the current unit, ideally fetched from the data via xslt or hard coded as below -->
                <meta name="citation_author" content="Foo, Bar"/>
                <meta name="citation_author" content="Bar, Foo"/>
                <link rel="stylesheet" href="css/editions-toc.css" type="text/css"></link>
            </head>
            <body class="d-flex flex-column h-100" data-bs-spy="scroll" data-bs-target="#toc">
                <xsl:call-template name="nav_bar"/>
                <main id="main" tabindex="-1" class="flex-shrink-0 flex-grow-1">
                    <nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb" class="ps-5 p-3">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item">
                                <a href="index.html">
                                    <xsl:value-of select="$project_short_title"/>
                                </a>
                            </li>
                            <li class="breadcrumb-item">
                                <a href="toc.html">
                                    <xsl:value-of select="'Inhaltsverzeichnis'"/>
                                </a>
                            </li>
                            <li class="breadcrumb-item active" aria-current="page">
                                <xsl:value-of select="$doc_title"/>
                            </li>
                        </ol>
                    </nav>
                    <div class="container">
                        <div class="row" id="siteHead">
                            <div class="col-md-2 col-lg-2 col-sm-12 text-start">
                                <xsl:if test="ends-with($prev,'.html')">
                                    <a>
                                        <xsl:attribute name="href">
                                            <xsl:value-of select="$prev"/>
                                        </xsl:attribute>
                                        <i class="fs-2 bi bi-chevron-left" title="Zurück zum vorigen Dokument" visually-hidden="true">
                                            <span class="visually-hidden">Zurück zum vorigen Dokument</span>
                                        </i>
                                    </a>
                                </xsl:if>
                            </div>
                            <div class="col-md-8 col-lg-8 col-sm-12 text-center">
                                <h1>
                                    <xsl:value-of select="$doc_title"/>
                                </h1>
                                <div>
                                    <a href="{$teiSource}">
                                        <i class="bi bi-download fs-2" title="Zum TEI/XML Dokument" visually-hidden="true">
                                            <span class="visually-hidden">Zum TEI/XML Dokument</span>
                                        </i>
                                    </a>
                                </div>
                            </div>
                            <div class="col-md-2 col-lg-2 col-sm-12 text-end">
                                <xsl:if test="ends-with($next, '.html')">
                                    <a>
                                        <xsl:attribute name="href">
                                            <xsl:value-of select="$next"/>
                                        </xsl:attribute>
                                        <i class="fs-2 bi bi-chevron-right" title="Weiter zum nächsten Dokument" visually-hidden="true">
                                            <span class="visually-hidden">Weiter zum nächsten Dokument</span>
                                        </i>
                                    </a>
                                </xsl:if>
                            </div>
                        </div>
                        
                        <div class="row" id="siteBody">
                            <div class="col-md-2">
                                <details class="d-md-none mb-3 toc-details">
                                    <summary>Table of Contents</summary>
                                    <nav class="js-toc sticky-top"
                                        title="page navigation">
                                        <ul class="nav flex-column">
                                            <li class="nav-item">
                                                <a class="nav-link" href="#about">About</a>
                                            </li>
                                            
                                            <li class="nav-item">
                                                <a class="nav-link" href="#witnesses">Witnesses</a>
                                                <ul class="nav flex-column ms-3">
                                                    <xsl:for-each select="//tei:listWit[@xml:id='witnesses']/tei:witness">
                                                        <xsl:variable name="witnessId" select="replace(@corresp, '#', '')"/>
                                                        <li class="nav-item">
                                                            <a class="nav-link" href="#{$witnessId}">
                                                                <xsl:value-of select="./tei:ref/text()"/>
                                                            </a>
                                                        </li>
                                                    </xsl:for-each>
                                                </ul>
                                            </li>
                                            <xsl:if test="count(//tei:witness) gt 1">
                                                <li class="nav-item">
                                                    <a class="nav-link" href="#synoptic-view">Synoptic views</a>
                                                    <ul class="nav flex-column ms-3">
                                                        <li class="nav-item" >
                                                            <a class="nav-link" href="#synoptic-view-original">original</a>
                                                        </li>
                                                        <li class="nav-item">
                                                            <a class="nav-link" href="#synoptic-view-translated">translated</a>
                                                        </li>
                                                    </ul>
                                                </li>
                                            </xsl:if>x
                                            <li class="nav-item">
                                                <a class="nav-link" href="#commentary">Commentary</a>
                                            </li>
                                        </ul>
                                    </nav>
                                </details>
                                <nav
                                    id="toc"
                                    class="js-toc sticky-top d-none d-md-block"
                                    style="max-height: calc(100vh - 2rem); overflow-y: auto;"
                                    aria-label="Page navigation"
                                    >
                                    <ul class="nav flex-column">
                                        <li class="nav-item">
                                            <a class="nav-link" href="#about">About</a>
                                        </li>
                                        
                                        <li class="nav-item">
                                            <a class="nav-link" href="#witnesses">Witnesses</a>
                                            <ul class="nav flex-column ms-3">
                                            <xsl:for-each select="//tei:listWit[@xml:id='witnesses']/tei:witness">
                                                <xsl:variable name="witnessId" select="replace(@corresp, '#', '')"/>
                                                    <li class="nav-item">
                                                        <a class="nav-link" href="#{$witnessId}">
                                                            <xsl:value-of select="./tei:ref/text()"/>
                                                        </a>
                                                    </li>
                                            </xsl:for-each>
                                            </ul>
                                        </li>
                                        <xsl:if test="count(//tei:witness) gt 1">
                                            <li class="nav-item">
                                                <a class="nav-link" href="#synoptic-view">Synoptic views</a>
                                                <ul class="nav flex-column ms-3">
                                                    <li class="nav-item" >
                                                        <a class="nav-link" href="#synoptic-view-original">original</a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a class="nav-link" href="#synoptic-view-translated">translated</a>
                                                    </li>
                                                </ul>
                                            </li>
                                        </xsl:if>
                                        
                                        <li class="nav-item">
                                            <a class="nav-link" href="#commentary">Commentary</a>
                                        </li>
                                        
                                    </ul>
                                </nav>
                            </div>
                            <div class="col-md-10">
                                <h2 id="about">About the colophon</h2>
                                <dl>
                                    <dt>date</dt>
                                    <dd><xsl:value-of select="//tei:sourceDesc/tei:listBibl[1]/tei:bibl/tei:date"/></dd>
                                    
                                    <dt>place</dt>
                                    <dd><xsl:value-of select="//tei:sourceDesc/tei:listBibl[1]/tei:bibl/tei:placeName"/></dd>
                                    
                                    <dt>identification</dt>
                                    <dd><xsl:apply-templates select="//tei:sourceDesc/tei:listBibl[1]/tei:bibl/tei:note[@type='identification']"/></dd>
                                    
                                    <dt>transmission</dt>
                                    <dd><xsl:apply-templates select="//tei:sourceDesc/tei:listBibl[1]/tei:bibl/tei:note[@type='transmission']"/></dd>
                                    
                                    <dt>uncertainty</dt>
                                    <dd><xsl:apply-templates select="//tei:sourceDesc/tei:listBibl[1]/tei:bibl/tei:note[@type='uncertainty']"/></dd>
                                    
                                    <dt>source</dt>
                                    <dd><xsl:apply-templates select="//tei:sourceDesc/tei:listBibl[1]/tei:bibl/tei:note[@type='source']"/></dd>
                                </dl>
                                <h2 id="witnesses">Witnesses</h2>
                                <xsl:for-each select="//tei:listWit[@xml:id='witnesses']/tei:witness">
                                    <xsl:variable name="witnessId" select="replace(@corresp, '#', '')"/>
                                    <h3 id="{$witnessId}" class="pt-5"><xsl:value-of select="./tei:ref"/></h3>
                                    <dl>
                                        <dt>locus</dt>
                                        <dd><xsl:apply-templates select="./tei:locus"/></dd>
                                        
                                        <dt>transmissionStatus</dt>
                                        <dd><xsl:apply-templates select="./tei:note[@type='transmissionStatus']"/></dd>
                                        
                                        <dt>dating</dt>
                                        <dd><xsl:apply-templates select="./tei:note[@type='dating']"/></dd>
                                    </dl>
                                    
                                    <h4>Transcription</h4>
                                    <xsl:for-each select="//tei:div[@xml:id=$witnessId]">
                                        <xsl:for-each select=".//tei:div[@type='folio']">
                                            <div class="row">
                                                <div class="col">
                                                    <xsl:apply-templates select="./tei:ab[@type='transcription']"/>
                                                </div>
                                                <div class="col">
                                                    <xsl:apply-templates select="./tei:ab[@type='translation']"/>
                                                </div>
                                            </div>
                                        </xsl:for-each>
                                    </xsl:for-each>
                                    <hr />
                                </xsl:for-each>
                                <xsl:if test="count(//tei:witness) gt 1">
                                    <h2 id="synoptic-view">synoptic View</h2>
                                    
                                    <h3 id="synoptic-view-original">Original</h3>
                                    <div class="row">
                                        <xsl:for-each select="//tei:div[@type='witness']">
                                            <div class="col">
                                                <xsl:apply-templates select=".//tei:ab[@type='transcription']"/>
                                            </div>
                                        </xsl:for-each>
                                    </div>
                                    <h3 id="synoptic-view-translated">Translated</h3>
                                    <div class="row">
                                        <xsl:for-each select="//tei:div[@type='witness']">
                                            <div class="col">
                                                <xsl:apply-templates select=".//tei:ab[@type='translation']"/>
                                            </div>
                                        </xsl:for-each>
                                    </div>
                                </xsl:if>
                                
                                <h2 id="commentary">Commetary</h2>
                                <div><xsl:apply-templates select="//tei:div[@type='commentary']"></xsl:apply-templates></div>
                            </div>
                         </div>
                        <div class="text-center p-4">
                            <xsl:call-template name="blockquote">
                                <xsl:with-param name="pageId" select="$link"/>
                            </xsl:call-template>
                        </div>

                    </div>
                    
                </main>
                <xsl:call-template name="html_footer"/>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
