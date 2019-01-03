/********************************************************************************/
/*																											*/
/*   System Name	: MSS																		*/
/*   1Depth Name		: �μ�����																	*/
/*   2Depth Name		: ���±׷�����                                                    						*/
/*   Program Name	: ���±׷�����                  		              							*/
/*   Program ID		: D40TmGroupFrameRFC.java											*/
/*   Description		: ���±׷�����																*/
/*   Note				: ����																			*/
/*   Creation  			: 2017-12-08 ������														*/
/*   Update   			: 2017-12-08 ������														*/
/*																											*/
/********************************************************************************/


package hris.D.D40TmGroup.rfc;


import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;


/**
 * OrganListRFC.java
 * ���ѿ� ���� ��ü ���� List�� �������� RFC�� ȣ���ϴ� Class
 *
 * @author  ������
 * @version 1.0, 2017/12/08
 */
public class D40TmGroupFrameRFC extends SAPWrap {

//	private String functionName = "ZGHR_RFC_TM_GET_ORGEH_LIST";
	private String functionName = "ZGHR_RFC_TM_TIME_GRUP";
//    /**
//     * ���±׷���� ��ȸ���� ��ȸ
//     * @return java.util.Vector
//     * @exception com.sns.jdf.GeneralException
//     */
//    public Vector<D40OrganInfoData> getOrganList(String I_PERNR, String I_AUTHOR, String I_DATUM, String I_SELTAB, Vector T_IMPORTA) throws GeneralException {
//
//        JCO.Client mConnection = null;
//        try{
//            mConnection = getClient();
//            JCO.Function function = createFunction(functionName) ;
//
//            setField(function, "I_PERNR", I_PERNR);
//            setField(function, "I_AUTHOR", I_AUTHOR);
//            setField(function, "I_DATUM", I_DATUM);
//            setField(function, "I_SELTAB", I_SELTAB);
//            //setField(function, "I_IMWON", "");
//
//            if(Utils.getSize(T_IMPORTA) > 0){
//                setTable(function, "T_IMPORTA", T_IMPORTA);
//            }
//            excute(mConnection, function);
//            if("B".equals(I_SELTAB)){
//            	return getTable(D40OrganInfoData.class,  function, "T_EXPORTB");
//            }else if("C".equals(I_SELTAB)){
//            	return getTable(D40OrganInfoData.class,  function, "T_EXPORTC");
//            }else{
//            	return getTable(D40OrganInfoData.class,  function, "T_EXPORTA");
//            }
//
//        } catch(Exception ex){
//            Logger.sap.println(this, "SAPException : "+ex.toString());
//            throw new GeneralException(ex);
//        } finally {
//            close(mConnection);
//        }
//    }

    /**
     * ���±׷� ����/��ȸ RFC
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
	public Vector getTmYyyyMmList(String empNo,	String I_GTYPE, String I_PABRJ, String I_PABRP, String I_SEQNO) throws GeneralException {
		JCO.Client mConnection = null;
        try{
        	mConnection = getClient();
            JCO.Function function = createFunction( functionName ) ;

            setField(function, "I_PERNR", empNo);
            setField(function, "I_GTYPE", I_GTYPE);
            setField(function, "I_PABRJ", I_PABRJ);
            setField(function, "I_PABRP", I_PABRP);
            setField(function, "I_SEQNO", I_SEQNO);
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

	/**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
//      ��� �Է� ���� ���� ����Ʈ ��ȸ
    	Vector ret = new Vector();
        String entityName = "hris.D.D40TmGroup.D40TmGroupData";
        String tableName  = "T_EXLIST";
        String tableName2  = "T_SEQNO";

    	Vector OBJPS_OUT  = getTable(entityName, function, tableName);
    	Vector OBJPS_OUT2  = getTable(entityName, function, tableName2);


    	String E_RETURN   = getReturn().MSGTY;
    	String E_MESSAGE   = getReturn().MSGTX;

    	String fieldName5 = "E_PABRJ";     // ���ÿ���
    	String E_OTEXT  = getField(fieldName5, function) ;
    	String fieldName6 = "E_PABRP";     // ���ÿ�
    	String E_ORGEH  = getField(fieldName6, function) ;

//    	String fieldName7 = "MSGTY";     //
//    	String E_RETURN  = getField(fieldName7, function) ;
//    	String fieldName8 = "MSGTX";     //
//    	String E_MESSAGE  = getField(fieldName8, function) ;

    	ret.addElement(OBJPS_OUT);
    	ret.addElement(OBJPS_OUT2);
    	ret.addElement(E_RETURN);
    	ret.addElement(E_MESSAGE);
    	ret.addElement(E_OTEXT);
    	ret.addElement(E_ORGEH);
        return ret;
    }

	public Vector saveData(String I_PERNR, String I_GTYPE, Vector OBJID, String I_PABRJ, String I_PABRP) throws GeneralException {
		JCO.Client mConnection = null;
        try{

            mConnection = getClient();
            JCO.Function function = createFunction( functionName ) ;

            setInput( function, OBJID, "T_IMLIST", I_PERNR, I_GTYPE, I_PABRJ, I_PABRP  );

            excute( mConnection, function );
        	Vector ret = new Vector();

        	String E_RETURN   = getReturn().MSGTY;
        	String E_MESSAGE   = getReturn().MSGTX;

        	ret.addElement(E_RETURN);
        	ret.addElement(E_MESSAGE);
            return ret;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
	}

	private void setInput(JCO.Function function, Vector entityVector, String tableName, String I_PERNR, String I_GTYPE, String I_PABRJ, String I_PABRP ) throws GeneralException {
        setTable(function, tableName, entityVector);
        String fieldName = "I_PERNR";
        setField( function, fieldName, I_PERNR );
        String fieldName1 = "I_GTYPE";
        setField( function, fieldName1, I_GTYPE );
        String fieldName2 = "I_PABRJ";
        setField( function, fieldName2, I_PABRJ );
        String fieldName3 = "I_PABRP";
        setField( function, fieldName3, I_PABRP );
    }

}


