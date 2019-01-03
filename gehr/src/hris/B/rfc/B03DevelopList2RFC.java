package hris.B.rfc;

import com.sns.jdf.*;
import com.sns.jdf.sap.SAPWrap;
import java.util.Vector;

public class B03DevelopList2RFC extends SAPWrap
{

    public B03DevelopList2RFC()
    {
        functionName = "ZHRE_RFC_DEVELOP_LIST2";
    }

    public Vector getDevelopList(String s, String s1, String s2, String s3)
        throws GeneralException
    {
        com.sap.mw.jco.JCO.Client client = null;
        try
        {
            client = getClient();
            com.sap.mw.jco.JCO.Function function = createFunction(functionName);
            setInput(function, s, s1, s2);
            excute(client, function);
            if(s3.equals("1"))
            {
                Vector vector3 = getOutput(function);
                Vector vector = vector3;
                return vector;
            }
            if(s3.equals("2"))
            {
                Vector vector4 = getOutput(function);
                Vector vector1 = vector4;
                return vector1;
            }
            Vector vector5 = getOutput2(function);
            Vector vector2 = vector5;
            return vector2;
        }
        catch(Exception exception1)
        {
            Logger.sap.println(this, " SAPException : " + exception1.toString());
            throw new GeneralException(exception1);
        }
        finally
        {
            close(client);
        }
    }

    private Vector getOutput(com.sap.mw.jco.JCO.Function function)
        throws GeneralException
    {
        String s = "hris.B.B03DevelopData";
        String s1 = "L_TAB";
        return getTable(s, function, s1);
    }

    private Vector getOutput2(com.sap.mw.jco.JCO.Function function)
        throws GeneralException
    {
        String s = "hris.B.B03DevelopData2";
        String s1 = "L_TAB2";
        return getTable(s, function, s1);
    }

    private void setInput(com.sap.mw.jco.JCO.Function function, String s, String s1, String s2)
        throws GeneralException
    {
        String s3 = "I_PERNR";
        String s4 = "I_BEGDA";
        String s5 = "I_SEQNR";
        setField(function, s3, s);
        setField(function, s4, s1);
        setField(function, s5, s2);
    }

    private String functionName;
}
