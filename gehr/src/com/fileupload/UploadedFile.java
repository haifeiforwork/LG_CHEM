// Copyright (C) 1998 by Jason Hunter <jhunter@acm.org>.  All rights reserved.
// Use of this class is limited.  Please see the LICENSE for more information.
package com.fileupload;

import java.io.*;
import java.util.*;
import javax.servlet.*;

import com.sns.jdf.Logger;

// A class to hold information about an uploaded file.
//
class UploadedFile {

  private String dir;
  private String filename;
  private String type;

  UploadedFile(String dir, String filename, String type) {
	this.dir = dir;
	this.filename = filename;
	this.type = type;
  }
  public String getContentType() {
	return type;
  }
  public File getFile() throws IOException {
	if (dir == null || filename == null) {
	  return null;
	}
	else {
	File f = new File(dir + File.separator + filename);

	//보안진단 1차 개선
	if( !f.getAbsolutePath().equals(f.getCanonicalPath())){
		try {
			throw new Exception("파일경로 및 파일명을 확인하십시오.");
		} catch (Exception e) {
			Logger.debug.println(e.getMessage());
		}
	}
	  return f;
	}
  }
  public String getFilesystemName() {
	return filename;
  }
}
