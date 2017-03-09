# coding: utf-8
class CheckTemparature
  def initialize
    @date = nil
    @time = nil
    @temparature = nil
  end
  attr_accessor :temparature

  # メッセージ本文作成
  def get_temparature_message
    # TEMPerにアクセスして情報更新
    call_temper

    # 応答用メッセージ本文作成
    create_result_text
  end
  
  # get TEMPer output
  def call_temper
    # call TEMPer (USB thermometer)
    output = `sudo /usr/local/bin/temper`          

    # format output
    tmp = output.split(" ")
    @date = tmp[0]
    @time = tmp[1]
    @temparature = tmp[2].to_f
  end

  # post to Slack channel
  def post_to_slack
    system("curl -X POST --data-urlencode 'payload={\"channel\": \"#hedgehogs\", \"username\": \"Toto, Min and Fumi\", \"text\": \"現在、小屋の気温は #{@temparature.round(1)}℃です\"}' https://hooks.slack.com/services/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")
  end

  def create_result_text
    if temparature > 30
      return "暑い！:sunny:冷房つけて！\n今#{temparature.round(1)}℃だよ。"
    elsif temparature > 20
      return "快適ー:heart:\n今#{temparature.round(1)}℃だよ。"
    elsif temparature > 18
      return "ちょっと寒い:snowman_without_snow:\n今#{temparature.round(1)}℃だよ。"
    else
      return "寒いの:snowman:ヒーター確認して:musical_note:\n今#{temparature.round(1)}℃だよ。"
    end
  end
  
end
