require 'faraday'

class Capcha

  RU_CAPCHA_SEND_URL = 'https://rucaptcha.com/in.php'
  RU_CAPCHA_RESPONSE_URL = 'https://rucaptcha.com/res.php'
  API_KEY = '93defdc80f46371f91af11a11ae6bd73'
  RESPONSE_TIMEOUT = 5

  def initialize(image_url)
    @image_url = image_url
  end

  def resolve
    image_base64 = download_capcha!
    id = send_request(image_base64)

    begin
      sleep 5
      response_kod, result_kod = get_result(id)
    end while response_kod != 'OK'

    result_kod
  end

  private

  attr_reader :image_url

  def send_request(image_base64)
    params = { key: API_KEY,
               method: :base64,
               body: image_base64 }

    response = Faraday.post(RU_CAPCHA_SEND_URL, params.to_json, 'Content-Type' => 'application/json')
    raise 'Сетевая ошибка при отправке capcha. body = ' + response.body unless response.status == 200
    raise 'Ошибка отправки capcha. body = ' + response.body unless response.body =~ /OK\|\d+$/

    response.body.split('|')[1]
  end

  def download_capcha!
    response = Faraday.get(@image_url)
    return Base64.strict_encode64(response.body) if response.status == 200

    raise 'Ошибка считывания capcha. status = ' + response.status
  end

  def get_result(id)
    params = { key: API_KEY,
               action: :get,
               id: id }

    response = Faraday.get(RU_CAPCHA_RESPONSE_URL, params, {'Accept' => 'application/json'})
    raise 'Сетевая ошибка при считывании результата capcha. body = ' + response.body unless response.status == 200

    return response.body.split('|') if response.body =~ /OK\|[\w\d]+$/

    return [response.body, nil] if response.body =~ /CAPCHA_NOT_READY|ERROR_NO_SLOT_AVAILABLE/

    raise 'Ошибка обработки capcha: ' + response.body
  end
end

#<img src="https://noqu.ru/bitrix/tools/captcha.php?captcha_code=04835a4f8ed8f6b0813e6ee5dc867d88" alt="Защита от автоматических сообщений">
# <img src="https://noqu.ru/bitrix/tools/captcha.php?captcha_code=01a6b0f629de0a619445ef8bca4ff61b" alt="Защита от автоматических сообщений">
# <img src="https://noqu.ru//bitrix/tools/captcha.php?captcha_code=0b4f65fcfa92bc43628a3d45b4445cf4" alt="Защита от автоматических сообщений">