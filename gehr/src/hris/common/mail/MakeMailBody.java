/*
 * 작성된 날짜: 2005. 1. 28.
 *
 */
package hris.common.mail;

import java.io.BufferedReader;
import java.io.FileReader;
import java.util.Properties;
import java.util.StringTokenizer;
/**
 * @author 이승희
 *
 */
public class MakeMailBody
{
    StringTokenizer st;
    BufferedReader  fbr;
    FileReader      fr;
    String          fn;
    Properties      MailSource;

    public MakeMailBody(String FileName,Properties hSource)
    {
        fn = FileName;
        MailSource = hSource;
    }

    public String SetSource(String source)
    {
        StringBuffer sbTemp = new StringBuffer();
        String       szTemp = "";
        String       szLT   = "";
        boolean  isToken = false;
        boolean  isMail = false;
        st = new StringTokenizer(source,"<",true);

//      Logger.debug(st.countTokens());

        while (st.hasMoreTokens()){
            szTemp = st.nextToken();
            if (szTemp.equals("<")){
                if (isToken){
                    isMail = false;
                } else {
                    isMail = true;
                } // end if
                szLT = "<";
                isToken = true;
            } else if (isToken && szTemp.length() > 8 && szTemp.substring(0,5).equals("mail:")){
                int index  = szTemp.indexOf('/');
                int index2 = szTemp.indexOf('>') + 1;
                if (index < 1 || index2 < 1){
                    //Logger.debug("szTemp =" + szTemp + "index = " + index + "index2 = " + index2);
                    return null;
                } // end if

                szTemp = MailSource.getProperty(szTemp.substring(5,index).trim() ,"") +
                    szTemp.substring(index2);
                isToken = false;
                isMail = true;
            } else {
                isToken = false;
                isMail = false;
            } // end if

            if (!isToken){
                if (isMail){
                    sbTemp.append(szTemp);
                } else {
                    sbTemp.append(szLT).append(szTemp);
                } // end if
            } else {
                if (!isMail){
                    sbTemp.append(szLT);
                } // end if
            } // end if

        } // end while
        return  sbTemp.toString();
    } // end SetSource

    public String MakeContents() throws Exception {

        String temp;
        StringBuffer    sbMc = new StringBuffer();

        fbr = new BufferedReader(new FileReader(fn));
        while ((temp = fbr.readLine()) != null){
            sbMc.append(SetSource(temp)).append("\n");
        } // end while
        fbr.close();

        return sbMc.length() > 1 ?  sbMc.toString(): null;

    }// end MakeContentx

    // 클래스를 만들어 결과 값을 주는 팩토리 메소드
    public static String create(String FileName,Properties hSource) throws Exception
    {
        return new MakeMailBody(FileName,hSource).MakeContents();
    } // end crteate

}
