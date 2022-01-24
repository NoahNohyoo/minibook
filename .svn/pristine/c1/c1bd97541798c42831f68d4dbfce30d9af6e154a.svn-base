package com.mini.locate;

import java.util.HashMap;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

public class GetLocateByAddr {
	
	@SuppressWarnings("rawtypes")
	public HashMap getLocate(String addr) {
		
		String getAddr = addr;
		String replaceAddr = getAddr.replace(" ", "%20");
		String googleApiUrl = "http://maps.googleapis.com/maps/api/geocode/xml?language=en&sensor=false&address=";
		String url = googleApiUrl+replaceAddr;
		
		String[] fieldNames ={"lat", "lng"};
		HashMap pub = new HashMap();

		try {

			DocumentBuilderFactory f = DocumentBuilderFactory.newInstance();
			DocumentBuilder b = f.newDocumentBuilder();
			
			Document doc = b.parse(url);
			doc.getDocumentElement().normalize();

			NodeList items = doc.getElementsByTagName("GeocodeResponse");

			for (int i = 0; i < items.getLength(); i++) {

				Node n = items.item(i);

				if (n.getNodeType() != Node.ELEMENT_NODE)
					continue;
				Element e = (Element) n;
				
				NodeList status = e.getElementsByTagName("status");
				Element statusElem = (Element) status.item(0);
				Node statusNode = statusElem.getChildNodes().item(0);
				
				if ("OK".equals(statusNode.getNodeValue())) {
					
					for(String name : fieldNames){
						NodeList titleList = e.getElementsByTagName(name);
						Element titleElem = (Element) titleList.item(0);
						Node titleNode = titleElem.getChildNodes().item(0);
						
						pub.put(name, titleNode.getNodeValue());
						
					}
				}
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return pub;
		
	}
	
}
