import JSZip from 'jszip';
import xsltString from '../assets/MODS_opus.xslt.js';

function readFile(file) {
  return new Promise((resolve) => {
    const reader = new FileReader();
    reader.onload = (evt) => {
      resolve(evt.target.result);
    };
    reader.readAsText(file);
  });
}

export function transformXML(files) {
  return Promise.all([
    readFile(files.modsXml),
    readFile(files.collectionsXslt),
    readFile(files.licencesXslt),
  ])
    .then(([
      modsXml,
      collectionsXslt,
      licencesXslt,
    ]) => {
      const finalXsltString = xsltString
        .replace(
          '__COLLECTIONS__DEFIONTION__',
          collectionsXslt
            .replace(/<xsl:stylesheet (.*)>/, '')
            .replace(/<\/xsl:stylesheet>/, ''),
        )
        .replace(
          '__LICENCES__DEFINITION__',
          licencesXslt
            .replace(/<xsl:stylesheet (.*)>/, '')
            .replace(/<\/xsl:stylesheet>/, ''),
        );

      const xmlString = modsXml
        .replace(/dcterms:/g, '')
        .replace(/<modsCollection (.*)>/, '<modsCollection>');
      const parser = new DOMParser();
      const xmlDoc = parser.parseFromString(xmlString, 'text/xml');
      const xsltDoc = parser.parseFromString(finalXsltString, 'text/xml');
      const xsltProcessor = new XSLTProcessor();
      xsltProcessor.importStylesheet(xsltDoc);
      const resultDocument = xsltProcessor.transformToDocument(xmlDoc);
      return [
        resultDocument.documentElement.outerHTML,
        finalXsltString,
      ];
    });
}

export function createZip(transformedXml) {
  const zipFile = new JSZip();
  zipFile.file('opus.xml', transformedXml);
  return zipFile.generateAsync({ type: 'blob' });
}
