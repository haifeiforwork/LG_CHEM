<%
   //���ϸ� 
    String filename = "ksea_sample.ppt";
    String szClientFile = new String(filename.getBytes("utf-8"),"8859_1"); 
    if(szClientFile != null) 
        szClientFile = szClientFile; 
    
    response.setContentType("application/unknown"); 

    com.fileupload.FtpClient ftp = new com.fileupload.FtpClient("165.244.234.72", "oracle", "oracle");
    ftp.cd("/user8/hris/j-image/ksea_ppt/");
    java.io.OutputStream os = new java.io.FileOutputStream("test.out");
    ftp.get("xxtestxx.ppt", os);
    ftp.close();

//    String szPath = szClientFile; 
//    java.io.File file = new java.io.File(szPath);// ������Դϴ�. 
//    byte b[] = new byte[4096]; 

//    response.setHeader("Content-Disposition", "attachment;filename="+szClientFile + ";"); 
 
//    if (file.isFile()){ 
//        java.io.BufferedInputStream  fin  = new java.io.BufferedInputStream(new java.io.FileInputStream(file)); 
//        java.io.BufferedOutputStream outs = new java.io.BufferedOutputStream(response.getOutputStream()); 
//        int read = 0; 
//        try { 
//            while ((read = fin.read(b)) != -1){ 
//                outs.write(b,0,read); 
//            } 
//            outs.close(); 
//            fin.close(); 
//        } catch (Exception e) {   
//
//        } finally { 
//            if(outs!=null) outs.close(); 
//            if(fin!=null) fin.close(); 
//        } 
//    }
%>
  

