package hris.E.E19Congra.rfc;

import hris.E.E19Congra.E19CongcondGlobalData;
import hris.E.E19Congra.E19CongcondData2;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import com.sns.jdf.util.CodeEntity;

public class E19CongraRFC extends SAPWrap{
	private String functionName1 = "ZGHR_RFC_CONGCOND_REQUEST";
	private String functionName2 = "ZGHR_RFC_CONGCOND_ENTRY";
	private String functionName3 = "ZGHR_RFC_CONGRA_DUP_CHECK";

	public Vector getCongraDetail(String empNo,String I_gtype,String I_celty,String I_famsa,String I_famy_code,String I_CELDT) throws GeneralException{

		JCO.Client mConnection = null;
        try{

        	Logger.debug.println("#####	ZGHR_RFC_CONGCOND_REQUEST");
        	Logger.debug.println("#####	empNo 			=	[ " + empNo				+ "	 ]");
        	Logger.debug.println("#####	I_gtype 			=	[ " + I_gtype 			+ "	 ]");
        	Logger.debug.println("#####	I_celty 			=	[ " + I_celty  			+ "	 ]");
        	Logger.debug.println("#####	I_famsa 			=	[ " + I_famsa 			+ "	 ]");
        	Logger.debug.println("#####	I_famy_code	=	[ " + I_famy_code	+ " ]");

            mConnection = getClient();
            JCO.Function function = createFunction(functionName1) ;

           // setInput1(function, empNo,I_gtype,I_celty,I_famsa,I_famy_code);
            setInput1(function, empNo,I_gtype,I_celty,I_famsa,I_famy_code,I_CELDT);

            excute(mConnection, function);

            Vector ret = null;
            ret = getOutput(function);

            return ret;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
	}

	//--------get name ----------------------
	public String getName(String empNo, String I_famsa ,String I_celty) throws GeneralException{
        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName2) ;

            setInput2(function, empNo,I_famsa,I_celty);

            excute(mConnection, function);

            return getField("E_ENAME", function);
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
	}
	//--------------get entry --------------------------------
	public Vector getEntryCode(String empNo,String I_famsa,String I_celty) throws GeneralException{
        JCO.Client mConnection = null;
        try{
        	Logger.debug.println("#####	경조/가족 유형 조회	 : ZGHR_RFC_CONGCOND_ENTRY");
        	Logger.debug.println("#####	empNo	=	[ " +	empNo	+ " ]");
        	Logger.debug.println("#####	I_celty	=	[ " +	I_celty	+ " ]");
        	Logger.debug.println("#####	I_famsa	=	[ " +	I_famsa	+ " ]");

            mConnection = getClient();
            JCO.Function function = createFunction(functionName2) ;

            setInput3(function, empNo,I_famsa,I_celty);

            excute(mConnection, function);

            Vector ret = null;
            ret = getOutput3(function);

            return ret;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
	}
	//------------------------------------------------check---------------------------
	//--------get name ----------------------
	public String getCheck(String empNo, String I_celty,String I_famy_code, String I_famsa ,String I_objps) throws GeneralException{
        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName3) ;

            setInput4(function, empNo,I_celty,I_famy_code,I_famsa,I_objps);

            excute(mConnection, function);

            return getField("E_FLAG", function);
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
	}
//  update: 2013-03-19  lixinxin  @v1.0    CSR：C20130315_92423 begin
   // private void setInput1(JCO.Function function, String empNo,String I_gtype,String I_celty,String I_famsa,String I_famy_code) throws GeneralException {
	private void setInput1(JCO.Function function, String empNo,String I_gtype,String I_celty,String I_famsa,String I_famy_code,String I_CELDT) throws GeneralException {
//     update: 2013-03-19  lixinxin  @v1.0  CSR：C20130315_92423  end
		String fieldName1 = "I_PERNR"            ;
        setField(function, fieldName1, empNo);
        String fieldName2 = "I_GTYPE"            ;
        setField(function, fieldName2, I_gtype);
        String fieldName3 = "I_CELTY"            ;
        setField(function, fieldName3, I_celty);
        String fieldName4 = "I_FAMSA"            ;
        setField(function, fieldName4, I_famsa);
        String fieldName5 = "I_FAMY_CODE"            ;
        setField(function, fieldName5, I_famy_code);
//      update: 2013-03-19  lixinxin  @v1.0  CSR：C20130315_92423 begin
        String fieldName6 = "I_CELDT"            ;
        setField(function, fieldName6, I_CELDT);
//      update: 2013-03-19  lixinxin  @v1.0  CSR：C20130315_92423  end
    }
    private void setInput2(JCO.Function function, String empNo,String I_famsa,String I_celty) throws GeneralException {
        String fieldName1 = "I_PERNR"            ;
        setField(function, fieldName1, empNo);
        String fieldName2 = "I_FAMSA"            ;
        setField(function, fieldName2, I_famsa);
        String fieldName3 = "I_CELTY"            ;
        setField(function, fieldName3, I_celty);

    }
    private void setInput3(JCO.Function function, String empNo,String I_famsa,String I_celty) throws GeneralException {
        String fieldName1 = "I_PERNR"            ;
        setField(function, fieldName1, empNo);
        String fieldName2 = "I_FAMSA"            ;
        setField(function, fieldName2, I_famsa);
        String fieldName3 = "I_CELTY"            ;
        setField(function, fieldName3, I_celty);

    }
    private void setInput4(JCO.Function function, String empNo,String I_celty,String I_famy_code,String I_famsa, String I_objps) throws GeneralException {
        String fieldName1 = "I_PERNR"            ;
        setField(function, fieldName1, empNo);
        String fieldName2 = "I_CELTY"            ;
        setField(function, fieldName2, I_celty);
        String fieldName3 = "I_FAMY_CODE"            ;
        setField(function, fieldName3, I_famy_code);
        String fieldName4 = "I_FAMSA"            ;
        setField(function, fieldName4, I_famsa);
        String fieldName5 = "I_OBJPS"            ;
        setField(function, fieldName5, I_objps);
    }
    private Vector getOutput(JCO.Function function) throws GeneralException {
    	E19CongcondGlobalData data = new E19CongcondGlobalData();
		Object obj = getStructor(data, function, "S_ITAB");
		Vector v = new Vector();
		v.addElement(obj);
		return v;
    }

    private Vector getOutput3(JCO.Function function) throws GeneralException {

        Vector sum = new Vector();
        String tableName1  = "T_ITAB1";
        Vector cel=getCodeVector( function, tableName1);
        String tableName2  = "T_ITAB2";

        Vector famy=getTable( E19CongcondData2.class,function, tableName2);
        String tableName3 = "T_ITAB3";
        Vector name=getTable( E19CongcondData2.class,function, tableName3);
        Vector Sret = new Vector();
        for(int i=0; i<famy.size(); i++){
        	E19CongcondData2 data = (E19CongcondData2)famy.get(i);
        	CodeEntity codeEntity = new CodeEntity();
        	codeEntity.code = data.FAMY_CODE ;
        	codeEntity.value = data.FAMY_TEXT;
        	Sret.addElement(codeEntity);
        }

        sum.addElement(cel);
        sum.addElement(famy);
        sum.addElement(name);
        sum.addElement(Sret);

        Logger.debug.println("sum   :  "  + sum.toString());

        return sum;
    }

}
