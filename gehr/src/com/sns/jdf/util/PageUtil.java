package com.sns.jdf.util;

import com.common.Global;
import com.common.Utils;
import com.sns.jdf.GeneralException;

import java.util.Vector;


public class PageUtil {
    private int LINE_PER_PAGE  ;
    private int PAGE_GROUP     ;
    private int totalRow       ;
    private int privePage      ;
    private int totalPage      ;
    private int currPage       ;
    private int viewPage       ;
    private int viewLine       ;
    private int pageGroup      ;
    private int totalPageGroup ;
    private int priorpage      ;
    private int nextpage       ;

    public PageUtil( Vector vt , String page ) throws GeneralException {
        try{

            if( page==null || page.equals( "" ) ){
                privePage = 1;
            } else {
                privePage = Integer.parseInt( page );
            }
            int size = vt.size();
			com.sns.jdf.Config conf = new com.sns.jdf.Configuration();
			int pageSize = Integer.parseInt( conf.get("com.sns.jdf.LINE_PER_PAGE") );
            int page_Group = Integer.parseInt( conf.get("com.sns.jdf.PAGE_GROUP") );
            pageSet( size, pageSize, page_Group );
		} catch( Exception e ) {
            com.sns.jdf.Logger.err.println(this, "DataUtil Exception. Failed create Configuration Object!  e : "+e.toString());
            throw new GeneralException( e );
		}
    }


    public PageUtil( int size , String page ) throws GeneralException {
        try{
            if( page==null || page.equals( "" ) ){
                privePage = 1;
            } else {
                privePage = Integer.parseInt( page );
            }
			com.sns.jdf.Config conf = new com.sns.jdf.Configuration();
			int pageSize = Integer.parseInt( conf.get("com.sns.jdf.LINE_PER_PAGE") );
            int page_Group = Integer.parseInt( conf.get("com.sns.jdf.PAGE_GROUP") );
            pageSet( size, pageSize, page_Group );
		} catch( Exception e ) {
            com.sns.jdf.Logger.err.println(this, "DataUtil Exception. Failed create Configuration Object!  e : "+e.toString());
		    throw new GeneralException( e );
        }
    }

    public PageUtil( Vector vt , String page, int pageSize, int page_Group ) throws GeneralException  {
        try{
            if( page==null || page.equals( "" ) ){
                privePage = 1;
            } else {
                privePage = Integer.parseInt( page );
            }
            int size = vt.size();
            pageSet( size, pageSize, page_Group );
        } catch( Exception e ) {
		    throw new GeneralException( e );
        }
    }

    public PageUtil( int size , String page, int pageSize, int page_Group ) throws GeneralException {
        try{
            if( page==null || page.equals( "" ) ){
                privePage = 1;
            } else {
                privePage = Integer.parseInt( page );
            }
            pageSet( size, pageSize, page_Group );
        } catch( Exception e ) {
		    throw new GeneralException( e );
        }
    }

    private void pageSet( int size , int pageSize, int page_Group ) throws GeneralException {
        try {
            LINE_PER_PAGE = pageSize;
            PAGE_GROUP = page_Group;
            totalRow = size;
            totalPage = (int)Math.ceil(totalRow / ( LINE_PER_PAGE +0.0 ) );
            currPage = privePage;
            viewPage = ( currPage -1 ) * LINE_PER_PAGE ;
            viewLine = ( currPage ) * LINE_PER_PAGE ;
            if(viewLine > totalRow){
                viewLine = totalRow;
            }
            pageGroup = (int)Math.ceil( currPage / ( PAGE_GROUP + 0.0 ) );
            totalPageGroup = (int)Math.ceil( totalPage / (PAGE_GROUP + 0.0) );
            priorpage = 1 + ( PAGE_GROUP * (pageGroup-2) );
            nextpage  = 1 + ( PAGE_GROUP * pageGroup );

            if( totalPage - currPage == 0){
                if((totalRow % LINE_PER_PAGE) != 0){
                viewLine = totalRow;
                }
            }
        } catch( Exception e ) {
		    throw new GeneralException( e );
        }
    }

    public String pageControl() throws GeneralException {
        try{
            StringBuffer sb = new StringBuffer();
            sb.append(controlLeft());
            sb.append(controlPage());
            sb.append(controlRight());
            return sb.toString();
        } catch( Exception e ) {
		    throw new GeneralException( e );
        }
    }

    public String getPageControl() throws GeneralException {
        return pageControl();
    }

    public int formRow() throws GeneralException {
        try {
            return viewPage;
        } catch( Exception e ) {
		    throw new GeneralException( e );
        }
    }

    public int toRow() throws GeneralException {
        try{
            return viewLine;
        } catch( Exception e) {
            throw new GeneralException( e );
        }
    }

    public int getFrom() throws GeneralException {
        return formRow();
    }

    public int getTo() throws GeneralException {
        return toRow();
    }

    public String controlPage() throws GeneralException {
        try{
            StringBuffer sb = new StringBuffer();
            int start = 1 + (PAGE_GROUP * (pageGroup-1));
            int end = PAGE_GROUP + (PAGE_GROUP * (pageGroup-1));
            if ( totalPage > 1 ){
                for( int i=start; i <= end; i++ ) {
                    if ( i != currPage  && i <= totalPage) {
                        sb.append(" <a href=\"javascript:pageChange("+ i +")\"><span>"+ i +"</span></a>        \n");
                        if( i != end && i != totalPage){
                            sb.append("|");
                        }
                    } else if(i == currPage && i <= totalPage){
                        sb.append(" <b><span> "+i+"</span></b>                 \n");
                        if( i != end && i != totalPage){
                            sb.append("|");
                        }
                    } else {
                        break;
                    }
                }
            }
            return sb.toString();
        } catch ( Exception e) {
            throw new GeneralException( e );
        }
    }

    public String controlLeft() throws GeneralException {
        try{
            StringBuffer sb = new StringBuffer();
            if ( totalPage > 1 ){
            	sb.append("<div class=\"paging\">");
                if( currPage > 1) {
                    sb.append("<a href=\"javascript:pageChange(1)\" onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('Image11','','"+ WebUtil.ImageURL + "icon_Darrow_prev_o.gif',1)\"><img name=\"Image11\" border=\"0\" src=\""+ WebUtil.ImageURL + "icon_Darrow_prev.gif\" align=absbottom></a> ");
                } else {
                    sb.append("<img name=\"Image11\" border=\"0\" src=\""+ WebUtil.ImageURL + "icon_Darrow_prev.gif\" align=absbottom> ");
                }  //onMouseOver=\"MM_swapImage('Image11','','"+ WebUtil.ImageURL + "icon_Darrow_prev_o.gif',1)   onMouseOut=\"MM_swapImgRestore()\" \">
                if( pageGroup > 1 ) {
                    sb.append("<a href=\"javascript:pageChange("+priorpage+")\" onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('Image12','','"+ WebUtil.ImageURL + "icon_arrow_prev_o.gif',1)\"><img name=\"Image12\" border=\"0\" src=\""+ WebUtil.ImageURL + "icon_arrow_prev.gif\" align=absbottom></a> ");
                } else {
                    sb.append("<img name=\"Image12\" border=\"0\" src=\""+ WebUtil.ImageURL + "icon_arrow_prev.gif\" align=absbottom> \n ");
                }//onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('Image12','','"+ WebUtil.ImageURL + "icon_arrow_prev_o.gif',1)\">
            }
            return sb.toString();
        } catch ( Exception e) {
            throw new GeneralException ( e );
        }
    }

    public String controlRight() throws GeneralException {
        try{
            StringBuffer sb = new StringBuffer();
            if ( totalPage > 1 ){
                if (pageGroup < totalPageGroup) {
                    sb.append("<a href=\"javascript:pageChange("+nextpage+")\" onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('Image13','','"+ WebUtil.ImageURL + "icon_arrow_next_o.gif',1)\"><img name=\"Image13\" border=\"0\" src=\""+ WebUtil.ImageURL + "icon_arrow_next.gif\" align=absbottom></a> ");
                } else {
                    sb.append("<img name=\"Image13\" border=\"0\" src=\""+ WebUtil.ImageURL + "icon_arrow_next.gif\" align=absbottom> \n ");
                }//onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('Image13','','"+ WebUtil.ImageURL + "icon_arrow_next_o.gif',1)\">
                if (currPage < totalPage) {
                    sb.append("<a href=\"javascript:pageChange("+totalPage+")\" onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('Image14','','"+ WebUtil.ImageURL + "icon_Darrow_next_o.gif',1)\"><img name=\"Image14\" border=\"0\" src=\""+ WebUtil.ImageURL + "icon_Darrow_next.gif\" align=absbottom></a> ");
                } else {
                    sb.append("<img name=\"Image14\" border=\"0\" src=\""+ WebUtil.ImageURL + "icon_Darrow_next.gif\" align=absbottom> \n");
                }//onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('Image14','','"+ WebUtil.ImageURL + "icon_Darrow_next_o.gif',1)\">
                sb.append("</div>");
            }
            return sb.toString();
        } catch ( Exception e) {
            throw new GeneralException ( e );
        }
    }

    public String pageInfo() throws GeneralException {
        try{
            StringBuffer sb = new StringBuffer();
            Global g = Utils.getBean("global");
            sb.append(g.getMessage("COMMON.PAGE.TOTAL", String.valueOf(totalRow)));
            sb.append("&nbsp;");
            sb.append(g.getMessage("COMMON.PAGE.CURRENT", String.valueOf(currPage), String.valueOf(totalPage)));
            return sb.toString();
        } catch (Exception e) {
            throw new GeneralException( e);
        }
    }

    public String getPageInfo() throws GeneralException {
        return pageInfo();
    }

    /*********************************************************************************
     *  사용방법
     *  PageUtil pu = new PageUtil ( int size , String page, String scriptName, int pageSize, int pageGroup ) ;
     *  pageSize 및 pageGroup은 디폴트값 세팅 가능
     *  for( int i = pu.fromLow(); i < pu.toLow(); i++ ) {
     *   실제로 표현되는 Vector 및 화면로직
     *  }
     * <%= pu.controlPage() %> //링크부분 출력
     * jsp파일에
     * <input type="hidden" name="page" vlaue=""> 값을 추가한다.  현재 페이지를 찾기 위함
     * 페이지 변경을 위한 스크립트 생성
     * function pageChange(i) {
     *   page hidden fild의 값을 세팅하고 값을 가져올 jsp나 servlet을 호출
     * }
     ***********************************************************************************/

    /**
     * @return privePage을 리턴합니다.
     */
    public int getPrivePage()
    {
        return privePage;
    }
    /**
     * @param privePage 설정하려는 privePage.
     */
    public void setPrivePage(int privePage)
    {
        this.privePage = privePage;
    }
}
