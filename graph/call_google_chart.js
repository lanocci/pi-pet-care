google.load("visualization", "1", {packages:["corechart"]});
google.setOnLoadCallback(drawChart);
function drawChart() {
  var data = google.visualization.arrayToDataTable([
    ['Date', 'Temp'],
  {% for record in temp_list %}
    ['{{record.date}}',  {{record.temp}}],
  {% endfor %}
  ]);
  var options = {
    title: '{{title}}'
  };
  var chart = new google.visualization.LineChart(document.getElementById('chart_div'));
  chart.draw(data, options);
}
