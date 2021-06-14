import JSZip from 'jszip';
import axios from 'axios';
import xsltString from '../assets/MODS_opus.xslt.js';

export function transformXML(file) {
  return new Promise((resolve) => {
    const reader = new FileReader();
    reader.onload = (evt) => {
      const xmlString = evt.target.result
        .replace(/dcterms:/g, '')
        .replace(/<modsCollection (.*)>/, '<modsCollection>');
      const parser = new DOMParser();
      const xmlDoc = parser.parseFromString(xmlString, 'text/xml');
      const xsltDoc = parser.parseFromString(xsltString, 'text/xml');
      const xsltProcessor = new XSLTProcessor();
      xsltProcessor.importStylesheet(xsltDoc);
      const resultDocument = xsltProcessor.transformToDocument(xmlDoc);
      resolve(resultDocument.documentElement.outerHTML);
    };
    reader.readAsText(file);
  });
}

export function createZip(transformedXml) {
  const zipFile = new JSZip();
  zipFile.file('opus.xml', transformedXml);
  return zipFile.generateAsync({ type: 'blob' });
}

export function sendZip(model, zip) {
  return axios.post(
    `https://opus4.kobv.de/${model.company}/sword/deposit`,
    zip,
    {
      headers: {
        'Content-Type': 'application/zip',
      },
      auth: {
        username: model.username,
        password: model.password,
      },
    },
  );
  /*
    .then((response) => {
      console.log(response);
    })
    .catch((error) => {
      console.log(error);
    });
  */
}
