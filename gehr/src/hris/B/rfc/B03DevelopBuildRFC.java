package hris.B.rfc;

import com.sns.jdf.*;
import com.sns.jdf.sap.SAPWrap;
import hris.B.B03DevelopBuildData;
import java.util.Vector;

public class B03DevelopBuildRFC extends SAPWrap
{

    public B03DevelopBuildRFC()
    {
        functionName = "ZHRE_RFC_DEVELOP_BUILD";
    }

    public void build(Object obj, String s)
        throws GeneralException
    {
        com.sap.mw.jco.JCO.Client client = null;
        try
        {
            client = getClient();
            com.sap.mw.jco.JCO.Function function = createFunction(functionName);
            B03DevelopBuildData b03developbuilddata = (B03DevelopBuildData)obj;
            Vector vector = new Vector();
            vector.addElement(b03developbuilddata);
            setInput(function, s);
            setInput(function, vector, "DEVELOP_RESULT");
            excute(client, function);
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

    public void change(Object obj, String s, String s1, String s2, String s3)
        throws GeneralException
    {
        com.sap.mw.jco.JCO.Client client = null;
        try
        {
            client = getClient();
            com.sap.mw.jco.JCO.Function function = createFunction(functionName);
            B03DevelopBuildData b03developbuilddata = (B03DevelopBuildData)obj;
            Vector vector = new Vector();
            vector.addElement(b03developbuilddata);
            setInput(function, s, s1, s2, s3);
            setInput(function, vector, "DEVELOP_RESULT2");
            excute(client, function);
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

    public void delete(String s, String s1, String s2, String s3)
        throws GeneralException
    {
        com.sap.mw.jco.JCO.Client client = null;
        try
        {
            client = getClient();
            com.sap.mw.jco.JCO.Function function = createFunction(functionName);
            setInput(function, s, s1, s2, s3);
            excute(client, function);
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

    public void develop_build(Vector vector, String s)
        throws GeneralException
    {
        com.sap.mw.jco.JCO.Client client = null;
        try
        {
            client = getClient();
            com.sap.mw.jco.JCO.Function function = createFunction(functionName);
            setInput(function, s);
            setInput(function, vector, "DEVELOP2_RESULT");
            excute(client, function);
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

    public void develop_change(Vector vector, String s, String s1, String s2, String s3)
        throws GeneralException
    {
        com.sap.mw.jco.JCO.Client client = null;
        try
        {
            client = getClient();
            com.sap.mw.jco.JCO.Function function = createFunction(functionName);
            setInput(function, s, s1, s2, s3);
            setInput(function, vector, "DEVELOP2_RESULT2");
            excute(client, function);
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
        String s1 = "I_GUBUN";
        setField(function, s1, s);
    }

    private void setInput(com.sap.mw.jco.JCO.Function function, String s, String s1, String s2, String s3)
        throws GeneralException
    {
        String s4 = "I_PERNR";
        setField(function, s4, s);
        String s5 = "I_BEGDA";
        setField(function, s5, s1);
        String s6 = "I_SEQNR";
        setField(function, s6, s2);
        String s7 = "I_GUBUN";
        setField(function, s7, s3);
    }

    private void setInput(com.sap.mw.jco.JCO.Function function, Vector vector, String s)
        throws GeneralException
    {
        setTable(function, s, vector);
    }

    private String functionName;
}
