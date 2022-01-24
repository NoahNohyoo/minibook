package com.mini.util;

import javax.servlet.http.Part;

public class FileName {
	
	public static String getFileName(Part part) {
		String fileName = null;
		String headValue = part.getHeader("content-disposition");
		String[] elements = headValue.split(";");
		for (String el : elements) {
			if(el.trim().startsWith("filename")) {
				fileName = el.substring(el.indexOf('=')+1).replace("\"", "");
			}
		}
		return fileName;
	}
}
