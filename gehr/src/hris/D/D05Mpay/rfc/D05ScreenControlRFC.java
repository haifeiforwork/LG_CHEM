// Decompiled by DJ v3.4.4.74 Copyright 2003 Atanas Neshkov  Date: 2007-08-31 ¿ÀÈÄ 2:04:37
// Home Page : http://members.fortunecity.com/neshkov/dj.html  - Check often for new version!
// Decompiler options: packimports(3)
// Source File Name:   D05ScreenControlRFC.java

package hris.D.D05Mpay.rfc;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

public class D05ScreenControlRFC extends SAPWrap
{

    public D05ScreenControlRFC()
    {
    	functionName = "ZGHR_RFC_PAYSCREEN_CHECK";
    }

    public String getScreenCheckYn(String s)
        throws GeneralException {

        if(!getSapType().isLocal()) return "Y";

        com.sap.mw.jco.JCO.Client client = null;
        try
        {
            client = getClient();
            com.sap.mw.jco.JCO.Function function = createFunction(functionName);
            setInput(function, s);
            excute(client, function);
            String s2 = "E_CHECK";
            String s3 = getField(s2, function);
            String s1 = s3;
            return s1;
        }
        catch(Exception exception1)
        {
            Logger.sap.println(this, "SAPException : " + exception1.toString());
            throw new GeneralException(exception1);
        }
        finally
        {
            close(client);
        }
    }

    private void setInput(com.sap.mw.jco.JCO.Function function, String s)
        throws GeneralException
    {
        String s1 = "I_PERNR";
        setField(function, s1, s);
    }

    private String functionName;
}