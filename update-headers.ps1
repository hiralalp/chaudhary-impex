# Script to update headers on all HTML files

# Define the new header template
$newHeaderTemplate = @'
    <!-- Top Bar -->
    <div class="top-bar">
        <div class="container">
            <div class="top-bar-content">
                <div class="top-bar-left">
                    <a href="tel:+912266157017">📞 +91 8003801338 / +91 9152802542</a>
                </div>
                <div class="top-bar-right">
                    <a href="mailto:info@torqbolt.com">✉ info@torqbolt.com</a>
                </div>
            </div>
        </div>
    </div>

    <!-- Main Header -->
    <header class="main-header">
        <div class="container">
            <div class="header-content">
                <a href="INDEXPATH" class="logo">
                    Torq<span style="color: #ff0000;">Bolt</span>
                </a>
                <nav class="main-nav">
                    <ul>
                        <li class="dropdown">
                            <a href="BASEPATH/about.html" class="dropdown-toggle">ABOUT US</a>
                            <ul class="dropdown-menu">
                                <li><a href="BASEPATH/about.html">Company Profile</a></li>
                                <li><a href="BASEPATH/certifications.html">Certifications</a></li>
                                <li><a href="BASEPATH/quality.html">Quality Assurance</a></li>
                            </ul>
                        </li>
                        <li class="dropdown">
                            <a href="BASEPATH/products.html" class="dropdown-toggle">PRODUCTS</a>
                            <ul class="dropdown-menu">
                                <li><a href="BASEPATH/products/bolting.html">Bolting</a></li>
                                <li><a href="BASEPATH/products/springs.html">Springs</a></li>
                                <li><a href="BASEPATH/products/forgings.html">Forgings</a></li>
                                <li><a href="BASEPATH/products/retaining-rings.html">Rings</a></li>
                                <li><a href="BASEPATH/products/plugs.html">Plugs</a></li>
                                <li><a href="BASEPATH/products/pins.html">Pins</a></li>
                                <li><a href="BASEPATH/products/thimbles.html">Thimbles</a></li>
                                <li><a href="BASEPATH/products/keys.html">Keys</a></li>
                            </ul>
                        </li>
                        <li><a href="BASEPATH/materials.html">MATERIALS</a></li>
                        <li class="dropdown">
                            <a href="BASEPATH/technical.html" class="dropdown-toggle">TECHNICAL INTELLIGENCE</a>
                            <ul class="dropdown-menu">
                                <li><a href="BASEPATH/technical/specifications.html">Specifications</a></li>
                                <li><a href="BASEPATH/technical/dimensions.html">Dimensions</a></li>
                                <li><a href="BASEPATH/technical/threads.html">Threads</a></li>
                                <li><a href="BASEPATH/technical/surface-treatments.html">Surface Treatments</a></li>
                                <li><a href="BASEPATH/technical/applications.html">Applications</a></li>
                            </ul>
                        </li>
                        <li><a href="BASEPATH/contact.html">CONTACT</a></li>
                    </ul>
                </nav>
            </div>
        </div>
    </header>
'@

function Update-Header {
    param (
        [string]$FilePath,
        [string]$BasePath = "",
        [string]$IndexPath = "index.html"
    )
    
    if (-not (Test-Path $FilePath)) {
        return
    }
    
    $content = Get-Content $FilePath -Raw -Encoding UTF8
    
    # Replace BASEPATH and INDEXPATH placeholders
    $newHeader = $newHeaderTemplate
    $newHeader = $newHeader -replace 'BASEPATH/', $BasePath
    $newHeader = $newHeader -replace 'INDEXPATH', $IndexPath
    
    # Remove old header (from header to end header)
    $pattern = '(?s)<header>.*?</header>'
    if ($content -match $pattern) {
        $content = $content -replace $pattern, ''
    }
    
    # Insert new header after body tag
    $content = $content -replace '<body>', ("<body>`r" + $newHeader)
    
    Set-Content $FilePath $content -Encoding UTF8 -NoNewline
    Write-Host "Updated: $FilePath"
}

# Update root level files
Write-Host "Updating root level files..."
$rootFiles = Get-ChildItem "*.html" -Exclude "index.html"
foreach ($file in $rootFiles) {
    Update-Header -FilePath $file.FullName -BasePath "" -IndexPath "index.html"
}

# Update products/*.html
Write-Host "Updating products/*.html..."
$productsFiles = Get-ChildItem "products/*.html" -ErrorAction SilentlyContinue
foreach ($file in $productsFiles) {
    Update-Header -FilePath $file.FullName -BasePath "../" -IndexPath "../index.html"
}

# Update materials/*.html
Write-Host "Updating materials/*.html..."
$materialsFiles = Get-ChildItem "materials/*.html" -ErrorAction SilentlyContinue
foreach ($file in $materialsFiles) {
    Update-Header -FilePath $file.FullName -BasePath "../" -IndexPath "../index.html"
}

# Update technical/*.html
Write-Host "Updating technical/*.html..."
$technicalFiles = Get-ChildItem "technical/*.html" -ErrorAction SilentlyContinue
foreach ($file in $technicalFiles) {
    Update-Header -FilePath $file.FullName -BasePath "../" -IndexPath "../index.html"
}

# Update standards/*.html
Write-Host "Updating standards/*.html..."
$standardsFiles = Get-ChildItem "standards/*.html" -ErrorAction SilentlyContinue
foreach ($file in $standardsFiles) {
    Update-Header -FilePath $file.FullName -BasePath "../" -IndexPath "../index.html"
}

Write-Host "All headers updated successfully!"
