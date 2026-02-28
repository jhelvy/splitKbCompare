/**
 * export_layers.jsx
 * Exports each layer in overlays.ai as a separate SVG file.
 * Output folder: images/svg/ (next to the images/ folder)
 *
 * Run via: File > Scripts > Other Script... in Illustrator
 */

var doc = app.activeDocument;
var layers = doc.layers;
var totalLayers = layers.length;

// Output to images/svg/ relative to the .ai file location
var outputFolder = new Folder(doc.path + "/svg");
if (!outputFolder.exists) {
    outputFolder.create();
}

// Save original visibility state so we can restore it
var originalVisibility = [];
for (var i = 0; i < totalLayers; i++) {
    originalVisibility[i] = layers[i].visible;
}

// SVG export options — same settings for every layer so viewBox is consistent
function makeSVGOptions() {
    var opts = new ExportOptionsSVG();
    opts.compressed = false;                                          // plain .svg not .svgz
    opts.embedRasterImages = false;
    opts.fontType = SVGFontType.OUTLINEFONT;                         // convert text to paths
    opts.fontSubsetting = SVGFontSubsetting.None;
    opts.cssProperties = SVGCSSPropertyLocation.PRESENTATIONATTRIBUTES; // inline attrs, no classes
    opts.documentEncoding = SVGDocumentEncoding.UTF8;
    opts.includeFileInfo = false;
    opts.preserveEditability = false;
    opts.coordinatePrecision = 4;
    return opts;
}

var exported = 0;
var skipped = [];

for (var i = 0; i < totalLayers; i++) {
    var layer = layers[i];
    var layerName = layer.name;

    // Sanitize layer name for use as a filename
    var safeName = layerName
        .replace(/\s+/g, '_')
        .replace(/[^a-zA-Z0-9_\-]/g, '');

    if (safeName === '') {
        skipped.push(layerName + ' (empty name)');
        continue;
    }

    // Hide all layers, show only the current one
    for (var j = 0; j < totalLayers; j++) {
        layers[j].visible = false;
    }
    layer.visible = true;

    var outputFile = new File(outputFolder.fsName + "/" + safeName + ".svg");
    doc.exportFile(outputFile, ExportType.SVG, makeSVGOptions());
    exported++;
}

// Restore original visibility
for (var i = 0; i < totalLayers; i++) {
    layers[i].visible = originalVisibility[i];
}

var msg = "Done! Exported " + exported + " SVG files to:\n" + outputFolder.fsName;
if (skipped.length > 0) {
    msg += "\n\nSkipped " + skipped.length + " layers:\n" + skipped.join("\n");
}
alert(msg);
