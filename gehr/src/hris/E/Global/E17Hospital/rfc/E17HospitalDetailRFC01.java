package hris.E.Global.E17Hospital.rfc;

import hris.E.Global.E17Hospital.E17HospitalDetailData2;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

public class E17HospitalDetailRFC01 extends SAPWrap {

	    private String functionName = "ZGHR_RFC_REIMBURSE_FILE"; //"ZHRW_RFC_REIMBURSE_FILE";             //  ZHRS043S

	    private void setInput(JCO.Function function, String empNo,String ainf_seqn, String I_RTYPE ,  String type) throws GeneralException {
	        String fieldName = "I_PERNR";//社编
			setField( function, fieldName, empNo );
			String fieldName1 = "I_AINF_SEQN";//禀议号
			setField( function, fieldName1, ainf_seqn );
			String fieldName2 = "I_RTYPE"; //邀请类型
			setField( function, fieldName2, I_RTYPE );
			String fieldName3 = "I_GTYPE"; //处理类型
			setField( function, fieldName3, type );
	    }

	    private void setInput(JCO.Function function, Vector entityVector, String tableName) throws GeneralException {
	        setTable(function, tableName, entityVector);
	    }

	    public String build(String empNo,  String ainf_seqn, String rtype, String gtype, Vector tem) throws GeneralException {

	    	JCO.Client mConnection = null;
	        try{
	            mConnection = getClient();
	            JCO.Function function = createFunction(functionName) ;
	            setInput(function, empNo,ainf_seqn, rtype, gtype);
	            setInput(function, tem, "T_FILE"); //setInput(function, tem, "ITAB");
	            excute(mConnection, function);
	            return getField1("E_MESSAGE","E_RET_CODE", function);
	        } catch(Exception ex){
	            //Logger.sap.println(this, "SAPException : "+ex.toString());
	            throw new GeneralException(ex);
	        } finally {
	            close(mConnection);
	        }
		}

	     public Vector getMediDetail01(String empNo, String ainf_seqn,String rtype,  String gtype) throws GeneralException {

	         JCO.Client mConnection = null;
	         try{
	             mConnection = getClient();
	             JCO.Function function = createFunction(functionName) ;
	             setInput(function, empNo,ainf_seqn, rtype, gtype);
	             excute(mConnection, function);
	             Vector map = getTable( E17HospitalDetailData2.class,function, "T_FILE");//getOutput1(function);
	             return map;
	         } catch(Exception ex){
	             //Logger.sap.println(this, "SAPException : "+ex.toString());
	             throw new GeneralException(ex);
	         } finally {
	             close(mConnection);
	         }
	     }
	     private Vector getOutput2(JCO.Function function) throws GeneralException {
	 	    String tableName2 = "T_FILE";
	 	    //String entity= "hris.E.Global.E17Hospital.E17HospitalDetailData2";
	 	    return getTable( E17HospitalDetailData2.class,function, tableName2);
	 	}


	     public String delete(String empNo, String ainf_seqn, String rtype,  String gtype) throws GeneralException {

	         JCO.Client mConnection = null;
	         try{
	             mConnection = getClient();
	             JCO.Function function = createFunction(functionName) ;
	             setInput(function, empNo, ainf_seqn, rtype, "4");
	             excute(mConnection, function);
	             return getField("E_MESSAGE", function);
	         } catch(Exception ex){
	             //Logger.sap.println(this, "SAPException : "+ex.toString());
	             throw new GeneralException(ex);
	         } finally {
	             close(mConnection);
	         }
	     }

}
