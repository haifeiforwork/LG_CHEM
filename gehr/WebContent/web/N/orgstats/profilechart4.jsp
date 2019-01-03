<!DOCTYPE html >
<html>
<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<head>
    <link rel="stylesheet" href="demos.css" type="text/css" media="screen" />
    
    <script src="<%= WebUtil.ImageURL %>RGraph/libraries/RGraph.common.core.js" ></script>
    <script src="<%= WebUtil.ImageURL %>RGraph/libraries/RGraph.common.dynamic.js" ></script>
    <script src="<%= WebUtil.ImageURL %>RGraph/libraries/RGraph.common.effects.js" ></script>
    <script src="<%= WebUtil.ImageURL %>RGraph/libraries/RGraph.line.js" ></script>
    
    <title>Line chart with Trace effect</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <meta name="robots" content="noindex,nofollow" />
    <meta name="description" content="A Line chart with Trace effect" />
     
</head>
<body>

    <h1>Line chart with Trace effect</h1>

    <div>
        <canvas id="cvs" width="600" height="250">[No canvas support]</canvas>
    </div>
    
    <script>
        window.onload = function ()
        {
            var line = new RGraph.Line({
                id: 'cvs',
                //data: [84,-5,-10,-26,-45,12,84,73,60],
                data: [[1,3],[3,2],[2,1]],
                options: {
                    //labels: ['A','B','C'],
                    //colors: ['black']
                    //shadowOffsetx: 1,
                    //shadowOffsety: 1,
                    //linewidth: 2,
                    //yaxispos: 'right',
                    //xaxispos: 'center',
                    //gutterRight: 35,
                    //backgroundGridAutofitNumvlines: 8,
                    //textAccessible: true
                }
            }).trace2({frames: 60});
        }
    </script>







    <p></p>

    This goes in the documents header:
    <pre class="code">
&lt;script src="RGraph.common.core.js"&gt;&lt;/script&gt;
&lt;script src="RGraph.common.dynamic.js"&gt;&lt;/script&gt;
&lt;script src="RGraph.common.effects.js"&gt;&lt;/script&gt;
&lt;script src="RGraph.line.js"&gt;&lt;/script&gt;
</pre>
    
    Put this where you want the chart to show up:
    <pre class="code">
&lt;canvas id="cvs" width="600" height="250"&gt;
    [No canvas support]
&lt;/canvas&gt;
</pre>

    This is the code that generates the chart:
    <pre class="code">
&lt;script&gt;
    window.onload = function ()
    {
        var line = new RGraph.Line({
            id: 'cvs',
            data: [84,-5,-30,-26,-45,12,84,73,60],
            options: {
                labels: ['中','Gary','Neil','Jay','Helga','정','Kev','Luis','Pete'],
                colors: ['black'],
                shadowOffsetx: 1,
                shadowOffsety: 1,
                linewidth: 2,
                yaxispos: 'right',
                xaxispos: 'center',
                gutterRight: 35,
                backgroundGridAutofitNumvlines: 8,
                textAccessible: true
            }
        }).trace2({frames: 60});
    });
&lt;/script&gt;
</pre>



    <p>
        <a href="https://www.facebook.com/sharer/sharer.php?u=http://www.rgraph.net" target="_blank" onclick="window.open('https://www.facebook.com/sharer/sharer.php?u=http://www.rgraph.net', null, 'top=50,left=50,width=600,height=368'); return false"><img src="../images/facebook-large.png" width="200" height="43" alt="Share on Facebook" border="0" title="Visit the RGraph Facebook page" /></a>
        <a href="https://twitter.com/_rgraph" target="_blank" onclick="window.open('https://twitter.com/_rgraph', null, 'top=50,left=50,width=700,height=400'); return false"><img src="../images/twitter-large.png" width="200" height="43" alt="Share on Twitter" border="0" title="Mention RGraph on Twitter" /></a>
         
    </p>



    <p>
        <a href="./">&laquo; Back</a>
    </p>

</body>
</html>