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
    <xsl:output encoding="UTF-8" media-type="text/html" method="html" version="5.0" indent="yes" omit-xml-declaration="yes"/>


    <xsl:template match="/">
        <xsl:variable name="doc_title">
            <xsl:value-of select=".//tei:titleStmt/tei:title[@level='a']/text()"/>
        </xsl:variable>
        <xsl:variable name="link" select="'listformular.html'"/>
        <html class="h-100" lang="{$default_lang}">
            
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$doc_title"></xsl:with-param>
                </xsl:call-template>
                <xsl:call-template name="zoterMetaTags">
                    <xsl:with-param name="pageId" select="$link"></xsl:with-param>
                    <xsl:with-param name="zoteroTitle" select="$doc_title"></xsl:with-param>
                </xsl:call-template>
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
                            <li class="breadcrumb-item active" aria-current="page">
                                <xsl:value-of select="$doc_title"/>
                            </li>
                        </ol>
                    </nav>
                    <div class="container">
                        <h1>
                            <xsl:value-of select="$doc_title"/>
                        </h1>
                        
                        <div class="row" id="siteBody">
                            <div class="col-md-2">
                                <!--<details class="d-md-none mb-3 toc-details">
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
                                </details>-->
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
                                            <a class="nav-link" href="#categories">Categories</a>
                                            <ul class="nav flex-column ms-1">
                                                <xsl:for-each select="//tei:encodingDesc/tei:classDecl/*/tei:category[@n]">
                                                    
                                                    <li class="nav-item">
                                                        <a class="nav-link" href="#{@xml:id}">
                                                            <xsl:value-of select="@n"/>
                                                        </a>
                                                        <ul class="nav flex-column ms-2">
                                                            <xsl:for-each select="./tei:category">
                                                                <li class="nav-item">
                                                                    <a class="nav-link" href="#{@xml:id}">
                                                                        <xsl:value-of select="@n"/>
                                                                    </a>
                                                                </li>
                                                            </xsl:for-each>
                                                        </ul>
                                                    </li>
                                                </xsl:for-each>
                                            </ul>
                                        </li>
                                        
                                        
                                        <li class="nav-item">
                                            <a class="nav-link" href="#commentary">Commentary</a>
                                        </li>
                                        
                                    </ul>
                                </nav>
                            </div>
                            <div class="col-md-10">
                                <h2 id="about">About</h2>
                                <xsl:apply-templates select=".//tei:encodingDesc/tei:editorialDecl"/>
                                <h2 id="categories">Categories</h2>
                                <xsl:for-each select=".//tei:encodingDesc/tei:classDecl/*/tei:category[@n]">
                                    <h3 id="{./@xml:id}" class="ms-2">
                                        <xsl:value-of select="@n"/>
                                    </h3>
                                    <p class="lead"><xsl:apply-templates select="./tei:catDesc"></xsl:apply-templates></p>
                                    <xsl:for-each select="./tei:category">
                                        <h4 id="{@xml:id}" class="ms-4">
                                            <xsl:value-of select="@n"/>
                                        </h4>
                                        <p><xsl:apply-templates select="./tei:catDesc"/></p>
                                        <xsl:for-each select="./tei:category">
                                            <h5 id="{@xml:id}" class="ms-6">
                                                <xsl:value-of select="@n"/>
                                            </h5>
                                            <p><xsl:apply-templates select="./tei:catDesc[1]"/></p>
                                            <h6>Attestations</h6>
                                            <xsl:for-each select="./tei:catDesc[@corresp]">
                                                <figure>
                                                    <blockquote class="blockquote">
                                                        <p><xsl:value-of select="./tei:q"/></p>
                                                    </blockquote>
                                                    <figcaption class="blockquote-footer">
                                                        <a href="{replace(./tei:q/@corresp, '.xml', '.html')}"><xsl:value-of select="./tei:ref"/></a>
                                                    </figcaption>
                                                </figure>
                                            </xsl:for-each>
                                            
                                        </xsl:for-each>
                                    </xsl:for-each>
                                    
                                </xsl:for-each>
                            </div>
                        </div>
                        
                        <div class="text-center p-4">
                            <xsl:call-template name="blockquote">
                                <xsl:with-param name="pageId" select="'listperson.html'"/>
                            </xsl:call-template>
                        </div>
                    </div>
                </main>
                <xsl:call-template name="html_footer"/>
                
            </body>
        </html>


        <!--<xsl:for-each select=".//tei:person[@xml:id]">
            <xsl:variable name="filename" select="concat(./@xml:id, '.html')"/>
            <xsl:variable name="name" select="normalize-space(string-join(./tei:persName[1]//text()))"></xsl:variable>
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
                    </head>

                    <body class="d-flex flex-column h-100">
                        <xsl:call-template name="nav_bar"/>
                        <main id="main" tabindex="-1" class="flex-shrink-0 flex-grow-1">
                            <nav style="-\-bs-breadcrumb-divider: '>';" aria-label="breadcrumb" class="ps-5 p-3">
                                <ol class="breadcrumb">
                                    <li class="breadcrumb-item">
                                        <a href="index.html"><xsl:value-of select="$project_short_title"/></a>
                                    </li>
                                    <li class="breadcrumb-item">
                                        <a href="listperson.html"><xsl:value-of select="$doc_title"/></a>
                                    </li>
                                </ol>
                            </nav>
                            <div class="container">
                                <h1>
                                    <xsl:value-of select="$name"/>
                                </h1>
                                <xsl:call-template name="person_detail"/>
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
        </xsl:for-each>-->
    </xsl:template>
</xsl:stylesheet>