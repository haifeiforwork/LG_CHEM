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

	//�������� 1�� ����
	if( !f.getAbsolutePath().equals(f.getCanonicalPath())){
		try {
			throw new Exception("���ϰ�� �� ���ϸ��� Ȯ���Ͻʽÿ�.");
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
