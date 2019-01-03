package batch;//package batch;

import com.sns.jdf.Logger;

import java.io.File;
import java.io.FileWriter;
import java.io.PrintWriter;

public class LogMaker {
    
    public LogMaker()
    {
    
    }
    /**
     * ????? File??? ???  
     * @return ????? File??
     */
    public File getLogFile(String strFileName) throws Exception {

        File fileLog = new File(strFileName);

        return fileLog;
    }

    /**
     * ?? ?? ???? ??? ???? ??
     * @param strMessage String ???
     */
    public String makeMessage(String strMessage) {

         // ???? ???.
        StringBuffer sbMessage = new StringBuffer("");

        // ?? ??? ???.
        sbMessage.append("[");
        sbMessage.append(getPlainDate("yyyyMMdd"));
        sbMessage.append(" ");
        sbMessage.append(getPlainDate("HHmmss"));
        sbMessage.append("]");
        sbMessage.append("    ");

        // ???? ???.
        sbMessage.append(strMessage);

        return sbMessage.toString();
    }

    /**
     * ??? ??? ??
     * @param strMessage ???
     */
    public synchronized void writeLog(String strFile_Name, String strMessage) {

        FileWriter fwLog = null;
        PrintWriter pwLog = null;

        try {

            // ?? ??? ?? ??? ????.
            File fileLog = this.getLogFile(strFile_Name);

            fwLog = new FileWriter(fileLog.getAbsolutePath(), true);
            pwLog = new PrintWriter(fwLog);

            // ???? ????? ?
            pwLog.println(this.makeMessage(strMessage));
            pwLog.flush();

        } catch(Exception ex) {


        } finally {
            try {
                if(pwLog != null) pwLog.close();
                if(fwLog != null) fwLog.close();
            } catch(Exception ex) {
            }

        }
    }

    /**
     * ??? ??? ??
     * @param strMessage ???
     */
    public synchronized void writeLogExcel(String strFile_Name, String strMessage) {

        FileWriter fwLog = null;
        PrintWriter pwLog = null;

        try {

            // ?? ??? ?? ??? ????.
            File fileLog = this.getLogFile(strFile_Name);

            fwLog = new FileWriter(fileLog.getAbsolutePath(), true);
            pwLog = new PrintWriter(fwLog);

            // ???? ????? ?
            pwLog.println(strMessage);
            pwLog.flush();

        } catch(Exception ex) {

            Logger.debug("LogMaker.writeLog() : " + ex.toString());

        } finally {
            try {
                if(pwLog != null) pwLog.close();
                if(fwLog != null) fwLog.close();
            } catch(Exception ex) {
                Logger.debug("LogMaker.writeLog() :" + ex.toString());
            }

        }
    }

    /**
     * <pre System date? YYYYMMDD ??? ??</pre>
     *
     * @param
     * @return    ?? ? String
     */
    public static String getPlainDate(String sFormat) {
        java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat(sFormat);
        java.util.Date currentDate_1 = new java.util.Date();
        String date = formatter.format(currentDate_1);
        return date;
    }
}

