package hris.D.D01OT.rfc;

import java.util.Vector;
import javax.servlet.http.HttpServletRequest;
import org.apache.commons.lang.StringUtils;
import com.common.RFCReturnEntity;
import com.common.Utils;
import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import hris.D.D01OT.D01OTData;
import hris.common.approval.ApprovalSAPWrap;


/**
 * D01OTAFRFC.java
 * �ʰ��ٹ� ���Ľ�û ��ȸ/��û/����/���� RFC �� ȣ���ϴ� Class
 *
 * @author ������
 * @version 1.0, 2018/06/25
 */
@SuppressWarnings("rawtypes")
public class D01OTAFRFC extends ApprovalSAPWrap {

    private String functionName = "ZGHR_RFC_NTM_AFTOT_REQ";

    public D01OTAFRFC() {}

    public D01OTAFRFC(String empNo, String I_APGUB, String AINF_SEQN) throws GeneralException {

        setDetailInput(empNo, I_APGUB, AINF_SEQN);
    }

    /**
     * �ʰ��ٹ� ��ȸ RFC ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector<D01OTData> getDetail(String P_AINF_SEQN, String P_PERNR) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            excuteDetail(mConnection, function);

            Vector ret = new Vector();
            if (g.getSapType().isLocal())
            	ret= getTable(hris.D.D01OT.D01OTData.class, function, "T_RESULT");
            else
            	ret= getOutput(function);

            D01OTData data = (D01OTData) Utils.indexOf(ret,0);

            Vector ret_vt = new Vector();
            if (data!=null){
	            // �������� ó��
			    if(data.PBEG1.equals(data.PEND1) && data.PEND1.equals("00:00:00")){
				    data.PBEG1 = "";
				    data.PEND1 = "";
			    }
		    	if (data.PBEG2.equals(data.PEND2) && data.PBEG2.equals("00:00:00")){
				    data.PBEG2 = "";
				    data.PEND2 = "";
			    }
		    	ret_vt.addElement(data);
            }
			return ret_vt;

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * �ʰ��ٹ� ��û RFC ȣ���ϴ� Method
  	 * @param P_PERNR �������� �Ϸù�ȣ
     * @exception com.sns.jdf.GeneralException
     */
    public String build( String P_PERNR, Vector createVector , Box box, HttpServletRequest req)
    		throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            setInput(function, null, P_PERNR, "2", createVector);

             /* ����Ͽ��� ������� ���� ó�� */
            if(box.getObject("T_IMPORTA") != null)
                setTable(function, "T_IMPORTA", (Vector) box.getObject("T_IMPORTA"));

            return executeRequest(mConnection, function, box, req);
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * �ʰ��ٹ� ���� RFC ȣ���ϴ� Method
     * @param P_AINF_SEQN �������� �Ϸù�ȣ
     * @param P_PERNR �����ȣ
     * @exception com.sns.jdf.GeneralException
     */
    public String change( String P_AINF_SEQN, String P_PERNR, Vector createVector ,Box box,  HttpServletRequest req) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            setInput(function, P_AINF_SEQN, P_PERNR, "3", createVector);
//            excute(mConnection, function);
            return executeRequest(mConnection, function, box, req);

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * �ʰ��ٹ� ���� RFC ȣ���ϴ� Method
     * @param P_AINF_SEQN �������� �Ϸù�ȣ
     * @param P_PERNR �����ȣ
     * @exception com.sns.jdf.GeneralException
     */
    public RFCReturnEntity delete( String P_AINF_SEQN, String P_PERNR )  throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            setInput(function, P_AINF_SEQN, P_PERNR, "4");
           return  executeDelete(mConnection, function);

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }


    /**
     * RFC �������� Import ���� setting �Ѵ�.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @param job java.lang.String �������
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String key1, String key2, String job) throws GeneralException {
        setField( function, "I_AINF_SEQN", key1 );//"P_AINF_SEQN";
        setField( function, "I_ITPNR", key2 );;// "P_PERNR";
        setField( function, "I_GTYPE", job );//"P_CONT_TYPE";
    }


    /**
     * RFC �������� Import ���� setting �Ѵ�.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @param job java.lang.String �������
     * @param job java.util.Vector entityVector
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String P_AINF_SEQN, String P_PERNR,
    		String job, Vector entityVector) throws GeneralException {

        setField( function, "I_AINF_SEQN", P_AINF_SEQN ); //"P_AINF_SEQN";
        setField( function, "I_GTYPE", job );//"P_CONT_TYPE";
        if(StringUtils.isNotEmpty(P_PERNR)) setField( function,  "I_ITPNR", P_PERNR );// "P_PERNR";
//        setField( function,  "I_PERNR", P_PERNR );// "P_PERNR";

        if (g.getSapType().isLocal()){
        	setTable(function, "T_RESULT", entityVector); // "P_RESULT";
        }else{
        	// Global:
        	setStructor(function, "S_RESULT", entityVector.get(0));
        }
    }


	/**
	 * RFC �������� Import ���� setting �Ѵ�. com.sns.jdf.SAPWrap.excute(JCO.Client
	 * mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
	 *
	 * @param function
	 *            com.sap.mw.jco.JCO.Function
	 *            java.util.Vector
	 * @exception com.sns.jdf.GeneralException
	 */

	private Vector getOutput(JCO.Function function) throws GeneralException {
		D01OTData data = new D01OTData();
		D01OTData obj = (D01OTData)getStructor(data, function, "S_RESULT");//WA_ITAB

		if(obj.REASON.equals("")){	// QA�� zreason ����κ� �̹ݿ����� �ӽ���ġ*ksc
			obj.REASON = data.ZREASON;
		}

		Vector v = new Vector();
		v.addElement(obj);
		return v;
	}

}


