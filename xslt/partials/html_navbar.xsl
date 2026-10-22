<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0">
    <xsl:template name="nav_bar">
        <a class="visually-hidden-focusable" href="#main">Jump to content</a>
        <header>
            <nav aria-label="Primary" class="navbar navbar-expand-lg bg-body-tertiary">
                <div class="container-fluid">
                    <a class="navbar-brand" href="index.html">
                        <xsl:value-of select="$project_short_title"/>
                    </a>
                    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
                        <span class="navbar-toggler-icon"></span>
                    </button>
                    <div class="collapse navbar-collapse" id="navbarSupportedContent">
                        <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">Project</a>
                                <ul class="dropdown-menu">
                                    <li>
                                        <a class="dropdown-item" href="about.html">About the Project</a>
                                    </li>
                                    <li>
                                        <a class="dropdown-item" href="imprint.html">imprint</a>
                                    </li>
                                </ul>
                            </li>

                            <li class="nav-item">
                                <a class="nav-link" href="toc.html">Colophons</a>
                            </li>

                            <li class="nav-item dropdown disabled">
                                <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">Indices</a>
                                <ul class="dropdown-menu">
                                    <li>
                                        <a class="dropdown-item" href="listmanuscript.html">Manuscripts</a>
                                    </li>
                                    <li>
                                        <a class="dropdown-item" href="listformula.html">Formulas</a>
                                    </li>
                                    <li>
                                        <a class="dropdown-item" href="listbibl.html">Bibliography</a>
                                    </li>
                                    <li>
                                        <a class="dropdown-item" href="listperson.html">Persons</a>
                                    </li>
                                    <li>
                                        <a class="dropdown-item" href="listplace.html">Places</a>
                                    </li>
                                    
                                    <li>
                                        <a class="dropdown-item" href="listbibl.html">Works</a>
                                    </li>
                                </ul>
                            </li>
                            <li class="nav-item">
                                <a title="API" class="nav-link" href="api.xml">API</a>
                            </li>
                            <li class="nav-item">
                                <a title="Search" class="nav-link" href="search.html">Search</a>
                            </li>
                            <li class="nav-item">
                                <a title="Search" class="nav-link" href="noske-search.html">Noske-Search</a>
                            </li>
                        </ul>
                    </div>
                </div>
            </nav>
        </header>
    </xsl:template>
</xsl:stylesheet>