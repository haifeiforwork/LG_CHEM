package servlet.hris.common;

import java.io.*;
import java.net.URLEncoder;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sns.jdf.GeneralException;
import com.sns.jdf.servlet.EHRBaseServlet;

public class DownloadedFile extends EHRBaseServlet {

	@Override
	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {

		String fileName =  req.getParameter("fileName");
		String filePath =   req.getParameter("filePath");

		  try {
			fileName = new String(fileName.getBytes("ISO8859-1"),"UTF-8");

			// 先获取上传目录路径
			//String basePath = getServletContext().getRealPath("/aaa/");
			// 获取一个文件流

			File file = new File(filePath + fileName);
			if ( ! file.getAbsolutePath().equals(file.getCanonicalPath()) ){
			   throw new Exception("File path and file name checking");
			}

			InputStream in = new FileInputStream(file);

			// 如果文件名是中文，需要进行url编码
			fileName = URLEncoder.encode(fileName, "UTF-8");
			// 设置下载的响应头
			res.setHeader("content-disposition", "attachment;fileName=" + fileName.replace("\r", "").replace("\n",""));

			// 获取response字节流
			OutputStream out = res.getOutputStream();
			byte[] b = new byte[1024];
			int len = -1;
			while ((len = in.read(b)) != -1){
				out.write(b, 0, len);
			}
			// 关闭
			out.close();
			in.close();
		} catch (UnsupportedEncodingException e) {
			throw new  GeneralException(e);
		} catch (IOException e) {
			throw new GeneralException(e);
		} catch(Exception e) {
            throw new GeneralException(e);
        }

	}

}
