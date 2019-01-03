package hris.common.db;

import java.util.*;
import java.sql.*;

import com.sns.jdf.*;
import com.sns.jdf.db.*;
import com.sns.jdf.util.*;

import hris.common.*;

/**
 * AppLineDB.java
 *  주택자금융자 관련
 *  DB Table Name : "ZHRA003T"
 *
 * @author 김성일
 * @version 1.0, 2001/12/13
 * 2017-05-25   eunha    [CSR ID:3390354] 인사시스템 보안점검 미준수 사항 조치
 * 2018/07/26 rdcamel 사용안함.
 */
public class AppLineDB {

    Connection conn = null;

	public AppLineDB(Connection connection) {
		conn = connection;
	}

    /**
     * 결재 신청
     * @param java.util.Vector hris.common.AppLineData 결재정보 데이터의 vector
     * @return int
     * @exception com.sns.jdf.GeneralException
     */
    public int create(Vector AppLineData_vt) throws GeneralException {
        int result = 0;
		PreparedStatement pstmt = null;

        String tableName = null;
		try{
            tableName = DBUtil.getOwner() + "ZHRA003T";
            StringBuffer query = new StringBuffer();
            query.append(" insert into "+tableName+"( MANDT,      BUKRS,      PERNR,                    ");
            query.append("                            BEGDA,      AINF_SEQN,  UPMU_FLAG,                ");
            query.append("                            UPMU_TYPE,  APPR_TYPE,  APPU_TYPE,                ");
            query.append("                            APPR_SEQN,  OTYPE,      OBJID,                    ");
            query.append("                            APPU_NUMB )                                       ");
            query.append("                    values( ?,          ?,          ?,                        ");
            query.append("                            ?,          ?,          ?,                        ");
            query.append("                            ?,          ?,          ?,                        ");
            query.append("                            ?,          ?,          ?,                        ");
            query.append("                            ? )                                               ");

            pstmt = conn.prepareStatement(query.toString());

            for (int i = 0; i < AppLineData_vt.size(); i++) {

                AppLineData data = (AppLineData)AppLineData_vt.get(i);
                DataUtil.fixNull( data );
                // 사원번호Check
                if( data.APPL_PERNR.trim().equals("") ) {
                    Logger.debug.println(this,"결재자가 지정되지 않았습니다.");
                    throw new BusinessException("결재자가 지정되지 않았습니다.");
                }
                data.APPL_PERNR = DataUtil.fixEndZero(data.APPL_PERNR, 8);
                data.APPL_AINF_SEQN = DataUtil.fixEndZero(data.APPL_AINF_SEQN, 10);

                pstmt.setString( 1, data.APPL_MANDT     );
                pstmt.setString( 2, data.APPL_BUKRS     );
                pstmt.setString( 3, data.APPL_PERNR     );
                pstmt.setString( 4, data.APPL_BEGDA     );
                pstmt.setString( 5, data.APPL_AINF_SEQN );
                pstmt.setString( 6, data.APPL_UPMU_FLAG );
                pstmt.setString( 7, data.APPL_UPMU_TYPE );
                pstmt.setString( 8, data.APPL_APPR_TYPE );
                pstmt.setString( 9, data.APPL_APPU_TYPE );
                pstmt.setString(10, data.APPL_APPR_SEQN );
                pstmt.setString(11, data.APPL_OTYPE     );
                pstmt.setString(12, data.APPL_OBJID     );
                pstmt.setString(13, data.APPL_APPU_NUMB );

                JDFPreparedStatement jdfPstmt = new JDFPreparedStatement(this, query.toString(), pstmt);
                result = jdfPstmt.executeUpdate();
            }
        }
        catch (Exception e){
            throw new GeneralException(e);
        }
        finally {
            DBUtil.close(pstmt);
        }
		return result;
    }

    /**
     * 신청된 결재의 수정
     * @param java.util.Vector hris.common.AppLineData 결재정보 데이터의 vector
     * @return int
     * @exception com.sns.jdf.GeneralException
     */
    public int change(Vector AppLineData_vt) throws GeneralException {
        int result = 0;
		PreparedStatement pstmt = null;

        String tableName = null;
		try{
            tableName = DBUtil.getOwner() + "ZHRA003T";
            StringBuffer query = new StringBuffer();
            query.append(" update "+tableName+"                                                         ");
            query.append("    set MANDT     = ?,                                                        ");
            query.append("        BUKRS     = ?,                                                        ");
            query.append("        PERNR     = ?,                                                        ");
            query.append("        BEGDA     = ?,                                                        ");
            query.append("        AINF_SEQN = ?,                                                        ");
            query.append("        UPMU_FLAG = ?,                                                        ");
            query.append("        UPMU_TYPE = ?,                                                        ");
            query.append("        APPR_TYPE = ?,                                                        ");
            query.append("        APPU_TYPE = ?,                                                        ");
            query.append("        APPR_SEQN = ?,                                                        ");
            query.append("        OTYPE     = ?,                                                        ");
            query.append("        OBJID     = ?,                                                        ");
            query.append("        APPU_NUMB = ?                                                         ");
            query.append("  where MANDT     = ?                                                         ");
            query.append("    and BUKRS     = ?                                                         ");
            query.append("    and PERNR     = ?                                                         ");
            query.append("    and BEGDA     = ?                                                         ");
            query.append("    and AINF_SEQN = ?                                                         ");
            query.append("    and UPMU_FLAG = ?                                                         ");
            query.append("    and UPMU_TYPE = ?                                                         ");
            query.append("    and APPR_TYPE = ?                                                         ");
            query.append("    and APPU_TYPE = ?                                                         ");
            query.append("    and APPR_SEQN = ?                                                         ");

            pstmt = conn.prepareStatement(query.toString());

            for (int i = 0; i < AppLineData_vt.size(); i++) {
                AppLineData data = (AppLineData)AppLineData_vt.get(i);
                DataUtil.fixNull( data );
                // 사원번호Check
                if( data.APPL_PERNR.trim().equals("") ) {
                    Logger.debug.println(this,"결재자가 지정되지 않았습니다.");
                    throw new BusinessException("결재자가 지정되지 않았습니다.");
                }
                data.APPL_PERNR = DataUtil.fixEndZero(data.APPL_PERNR, 8);
                data.APPL_AINF_SEQN = DataUtil.fixEndZero(data.APPL_AINF_SEQN, 10);

                pstmt.setString( 1, data.APPL_MANDT     );
                pstmt.setString( 2, data.APPL_BUKRS     );
                pstmt.setString( 3, data.APPL_PERNR     );
                pstmt.setString( 4, data.APPL_BEGDA     );
                pstmt.setString( 5, data.APPL_AINF_SEQN );
                pstmt.setString( 6, data.APPL_UPMU_FLAG );
                pstmt.setString( 7, data.APPL_UPMU_TYPE );
                pstmt.setString( 8, data.APPL_APPR_TYPE );
                pstmt.setString( 9, data.APPL_APPU_TYPE );
                pstmt.setString(10, data.APPL_APPR_SEQN );
                pstmt.setString(11, data.APPL_OTYPE     );
                pstmt.setString(12, data.APPL_OBJID     );
                pstmt.setString(13, data.APPL_APPU_NUMB );
                pstmt.setString(14, data.APPL_MANDT     );
                pstmt.setString(15, data.APPL_BUKRS     );
                pstmt.setString(16, data.APPL_PERNR     );
                pstmt.setString(17, data.APPL_BEGDA     );
                pstmt.setString(18, data.APPL_AINF_SEQN );
                pstmt.setString(19, data.APPL_UPMU_FLAG );
                pstmt.setString(20, data.APPL_UPMU_TYPE );
                pstmt.setString(21, data.APPL_APPR_TYPE );
                pstmt.setString(22, data.APPL_APPU_TYPE );
                pstmt.setString(23, data.APPL_APPR_SEQN );

                Logger.debug.println(this,"change pstmt"+pstmt.toString());
                JDFPreparedStatement jdfPstmt = new JDFPreparedStatement(this, query.toString(), pstmt);
                result = jdfPstmt.executeUpdate();
            }
		}
		catch (Exception e){
			throw new GeneralException(e);
		}
		finally {
			DBUtil.close(pstmt);
		}
		return result;
    }

    /**
     * 신청된 결재의 신청취소
     * @param hris.common.AppLineData 결재정보 데이터
     * @return int
     * @exception com.sns.jdf.GeneralException
     */
    public int delete(AppLineData data) throws GeneralException {
        int result = 0;
		Statement stmt = null;
        String tableName = null;
        PreparedStatement pstmt = null; //[CSR ID:3390354] 인사시스템 보안점검 미준수 사항 조치
		try{
            tableName = DBUtil.getOwner() + "ZHRA003T";
            DataUtil.fixNull( data );
            // 사원번호Check
            if( data.APPL_PERNR.trim().equals("") ) {
                Logger.debug.println(this,"결재자가 지정되지 않았습니다.");
                throw new BusinessException("결재자가 지정되지 않았습니다.");
            }
            data.APPL_PERNR = DataUtil.fixEndZero(data.APPL_PERNR, 8);
            data.APPL_AINF_SEQN = DataUtil.fixEndZero(data.APPL_AINF_SEQN, 10);

            StringBuffer query = new StringBuffer();
            query.append(" delete from "+tableName+"                                                    ");
          //[CSR ID:3390354] 인사시스템 보안점검 미준수 사항 조치 start
            query.append("  where MANDT     = ?                                    						 ");
            query.append("    and BUKRS       = ?                                      						 ");
            query.append("    and PERNR       = ?                                                            ");
//          query.append("    and BEGDA     = '" + data.APPL_BEGDA + "'                                      ");
            query.append("    and AINF_SEQN = ?                                                            ");
            query.append("    and UPMU_TYPE = ?                                                           ");
            /*query.append("  where MANDT     = '" + data.APPL_MANDT + "'                                      ");
            query.append("    and BUKRS     = '" + data.APPL_BUKRS + "'                                      ");
            query.append("    and PERNR     = '" + data.APPL_PERNR + "'                                      ");
//          query.append("    and BEGDA     = '" + data.APPL_BEGDA + "'                                      ");
            query.append("    and AINF_SEQN = '" + data.APPL_AINF_SEQN + "'                                  ");
            query.append("    and UPMU_TYPE = '" + data.APPL_UPMU_TYPE + "'                                  ");*/

            /*stmt = conn.createStatement();
            JDFStatement jdfStmt = new JDFStatement(this, stmt);
            result = jdfStmt.executeUpdate(query.toString());*/

            pstmt = conn.prepareStatement(query.toString());
            pstmt.setString( 1, data.APPL_MANDT );
            pstmt.setString( 2, data.APPL_BUKRS );
            pstmt.setString( 3, data.APPL_PERNR );
            pstmt.setString( 4, data.APPL_AINF_SEQN );
            pstmt.setString( 5, data.APPL_UPMU_TYPE );
            JDFPreparedStatement jdfPstmt = new JDFPreparedStatement(this, query.toString(), pstmt);
            result = jdfPstmt.executeUpdate();
          //[CSR ID:3390354] 인사시스템 보안점검 미준수 사항 조치 end

		}
		catch (Exception e){
			throw new GeneralException(e);
		}
		finally {
			DBUtil.close(stmt);
		}
		return result;
    }

    /**
     * 추가 결재신청이 가능한지를 가리는 Method
     * @param hris.common.AppLineData 결재정보 데이터
     * @return boolean
     * @exception com.sns.jdf.GeneralException
     */
    public boolean canUpdate(AppLineData data) throws GeneralException {
        Statement stmt = null;
        PreparedStatement pstmt = null; //[CSR ID:3390354] 인사시스템 보안점검 미준수 사항 조치
        ResultSet rs   = null;
        boolean ret = false;
        String tableName = null;
		try{
            tableName = DBUtil.getOwner() + "ZHRA003T";
            DataUtil.fixNull( data );
            // 사원번호Check
            if( data.APPL_PERNR.trim().equals("") ) {
                Logger.debug.println(this,"결재자가 지정되지 않았습니다.");
                throw new BusinessException("결재자가 지정되지 않았습니다.");
            }
            data.APPL_PERNR = DataUtil.fixEndZero(data.APPL_PERNR, 8);
            data.APPL_AINF_SEQN = DataUtil.fixEndZero(data.APPL_AINF_SEQN, 10);

            StringBuffer query = new StringBuffer();
            query.append(" select count(*)                                                              ");
            query.append("   from "+tableName+"                                                       ");
          //[CSR ID:3390354] 인사시스템 보안점검 미준수 사항 조치 start
			query.append("  where MANDT     = ?                                    					");
			query.append("    and BUKRS     = ?                                     					");
			query.append("    and PERNR     = ?                                     					");
//          query.append("    and BEGDA     = '" + data.APPL_BEGDA + "'                                      ");
			query.append("    and AINF_SEQN = ?                                 						");
			query.append("    and UPMU_TYPE = ?                                  					");
			/*query.append("  where MANDT     = '" + data.APPL_MANDT + "'                                      ");
			query.append("    and BUKRS     = '" + data.APPL_BUKRS + "'                                      ");
			query.append("    and PERNR     = '" + data.APPL_PERNR + "'                                      ");
//          query.append("    and BEGDA     = '" + data.APPL_BEGDA + "'                                      ");
			query.append("    and AINF_SEQN = '" + data.APPL_AINF_SEQN + "'                                  ");
			query.append("    and UPMU_TYPE = '" + data.APPL_UPMU_TYPE + "'                                  ");
			*/
			query.append("    and APPR_STAT = 'A'                                                       ");


           /* stmt = conn.createStatement();
            JDFStatement jdfStmt = new JDFStatement(this, stmt);
			rs = jdfStmt.executeQuery(query.toString());*/

            pstmt = conn.prepareStatement(query.toString());
            pstmt.setString( 1, data.APPL_MANDT );
            pstmt.setString( 2, data.APPL_BUKRS );
            pstmt.setString( 3, data.APPL_PERNR );
            pstmt.setString( 4, data.APPL_AINF_SEQN );
            pstmt.setString( 5, data.APPL_UPMU_TYPE );
            JDFPreparedStatement jdfPstmt = new JDFPreparedStatement(this, query.toString(), pstmt);
            rs = jdfPstmt.executeQuery();
          //[CSR ID:3390354] 인사시스템 보안점검 미준수 사항 조치 end
            if( rs.next() ){
                if( rs.getInt(1) > 0) {
                    ret = false;
                } else {
                    ret = true;
                }
            }
            return ret;
        } catch( Exception e ){
            throw new GeneralException(e);
        } finally {
            DBUtil.close(rs, stmt);
        }
    }
}