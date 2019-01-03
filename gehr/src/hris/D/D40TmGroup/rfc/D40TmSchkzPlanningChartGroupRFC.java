/********************************************************************************/
/*																											*/
/*   System Name	: MSS																		*/
/*   1Depth Name		: �μ�����																	*/
/*   2Depth Name		: ��ȹ�ٹ����� - �ٹ���ȹǥ                              						*/
/*   Program Name	: ��ȹ�ٹ����� - �ٹ���ȹǥ                        							*/
/*   Program ID		: D40TmSchkzPlanningChartRFC.java								*/
/*   Description		: ��ȹ�ٹ����� - �ٹ���ȹǥ												*/
/*   Note				: ����																			*/
/*   Creation  			: 2017-12-08 ������														*/
/*   Update   			: 2017-12-08 ������														*/
/*																											*/
/********************************************************************************/

package hris.D.D40TmGroup.rfc;


import hris.D.D40TmGroup.D40TmSchkzPlanningChartCodeData;
import hris.D.D40TmGroup.D40TmSchkzPlanningChartData;
import hris.D.D40TmGroup.D40TmSchkzPlanningChartNoteData;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;


/**
 * D40TmSchkzPlanningChartGroupRFC.java
 * ��ȹ�ٹ����� > �ٹ���ȹǥ ��ȸ
 *
 * @author  ������
 * @version 1.0, 2017/12/08
 */
public class D40TmSchkzPlanningChartGroupRFC extends SAPWrap {

	private String functionName = "ZGHR_RFC_TM_GET_WORK_PLAN";
    /**
     * �ٹ���ȹǥ ��ȸ
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
	public Vector getPlanningChart(String empNo, String I_SELTAB, Vector OBJID, String I_DATUM, String I_SCHKZ) throws GeneralException {
		JCO.Client mConnection = null;
        try{
        	mConnection = getClient();
            JCO.Function function = createFunction( functionName ) ;

            setField(function, "I_DEPT", empNo);
            setField(function, "I_DATUM", I_DATUM);
            setField(function, "I_SCHKZ", I_SCHKZ);

            if("A".equals(I_SELTAB)){
            	setTable(function, "T_IMPORTA", OBJID);
            }else if("B".equals(I_SELTAB)){
            	setTable(function, "T_IMPORTB", OBJID);
            }else if("C".equals(I_SELTAB)){
            	setTable(function, "T_IMPORTC", OBJID);
            }
            excute( mConnection, function );

            Vector ret = getOutput( function );

            return ret;

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
	}


	private Vector getOutput(JCO.Function function) throws GeneralException {

    	Vector ret = new Vector();

    	Vector T_EXPORTA = getTable(D40TmSchkzPlanningChartData.class,  function, "T_EXPORTA");//�ٹ���ȹǥ-TITLE
    	Vector T_EXPORTB = getTable(D40TmSchkzPlanningChartNoteData.class,  function, "T_EXPORTB"); // �ٹ���ȹǥ-����Ÿ.
    	Vector T_TPROG = getTable(D40TmSchkzPlanningChartCodeData.class,  function, "T_TPROG"); //���ϱٹ��󼼼���
    	Vector T_SCHKZ = getTable(D40TmSchkzPlanningChartCodeData.class,  function, "T_SCHKZ"); //��ȹ�ٹ�


    	String E_RETURN   = getReturn().MSGTY;
    	String E_MESSAGE   = getReturn().MSGTX;

    	String E_INFO  = getField("E_INFO", function) ;	// �ȳ�����
//    	String E_DATUM  = getField("E_DATUM", function) ;	// ��ȸ������

//		ret.addElement(E_DATUM);	//��������
		ret.addElement(E_INFO);		//�ȳ�����
    	ret.addElement(E_RETURN);
    	ret.addElement(E_MESSAGE);
    	ret.addElement(T_SCHKZ);	//��ȹ�ٹ�
    	ret.addElement(T_TPROG);	//���ϱٹ��󼼼���
    	ret.addElement(T_EXPORTA);	//�ٹ���ȹǥ-TITLE
    	ret.addElement(T_EXPORTB);	//�ٹ���ȹǥ-DATA
        return ret;
    }



}


