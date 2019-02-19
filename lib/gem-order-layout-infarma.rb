require 'date'
require 'net/ftp'

module OrderLayout

  $ftp_url = ''
  $ftp_port = 0
  $ftp_user = ''
  $ftp_password = ''
  $ftp_passive = false
  $codClient = 0
  $numOrder = 0
  $clientCnpjOrder = 0
  $currentUserName = ''
  $establishmentCnpj = 0
  $comment = ''
  $marketingPolicyId = 0
  $deadlineId = 0

  def self.set_connect ftp_url, ftp_port
  	$ftp_url = ftp_url  #Rails.application.config.ftp_url
  	$ftp_port = ftp_port #Rails.application.config.ftp_port
  end

  def self.set_login user, password
  	$ftp_user = user #Rails.application.config.ftp_user
  	$ftp_password = password #ails.application.config.ftp_password
  end

  def self.set_ftp_passive isPassive
    $ftp_passive = isPassive # Rails.application.config.ftp_passive
  end

  def self.set_establishmentCnpj establishmentCnpj
    $establishmentCnpj = establishmentCnpj
  end

  def self.set_codClient codClient
    $codClient = codClient
  end

  def self.set_numOrder numOrder
    $numOrder = numOrder
  end

  def self.set_clientCnpjOrder clientCnpjOrder
    $clientCnpjOrder = clientCnpjOrder
  end
 
  def self.set_currentUserName currentUserName
    $currentUserName = currentUserName
  end

  def self.set_comment comment
    $comment = comment
  end

  def self.set_marketingPolicyId marketingPolicyId
    $marketingPolicyId = marketingPolicyId
  end

  def self.set_deadlineId deadlineId
    $deadlineId = deadlineId
  end

  def self.set_totalOrders totalOrders
    $totalOrders = totalOrders
  end

  def self.set_totalUnits totalUnits
    $totalUnits = totalUnits
  end

  #===========================
  #=cria pasta, se não existir
  #===========================
  def self.create_folder directory_name
    Dir.mkdir(directory_name) unless File.exists?(directory_name)
  end

  #=============================================
  #=Envia pedido via FTP para Pedido Eletrônico
  #=============================================
  def self.send_ftp directory_name

    # new(host = nil, user = nil, passwd = nil, acct = nil)
    # Creates and returns a new FTP object. If a host is given, a connection is made.
    # Additionally, if the user is given, the given user name, password, and (optionally) account are used to log in.
    ftp = Net::FTP.new(false)

    # connect(host, port = FTP_PORT)
    # Establishes an FTP connection to host, optionally overriding the default port.
    ftp.connect($ftp_url, $ftp_port)

    # login(user = "anonymous", passwd = nil, acct = nil)
    # string “anonymous” and the password is nil, a password of user@host is synthesized.
    # If the acct parameter is not nil, an FTP ACCT command is sent following the successful login.
    #ftp.login(Rails.application.config.ftp_user, Rails.application.config.ftp_password)
    ftp.login($ftp_user, $ftp_password)
 
    #When true, the connection is in passive mode. Default: false.
    #ftp.passive = Rails.application.config.ftp_passive
    ftp.passive = $ftp_passive

    #Changes the (remote) directory.
    ftp.chdir('/ped')

    ftp.put(directory_name)
    ftp.close

  end


  #===================
  #=Cria arquivo .ped
  #===================
  def self.create_order_file order

    today = DateTime.now
    date = "#{today.year}#{"%02i" % today.month}#{"%02i" % today.day}"

    create_folder directory_name = "public/orders"
    create_folder directory_name = "#{directory_name}/#{date}"
    create_folder directory_name = "#{directory_name}/#{$codCliente}"

    out_file = File.new("#{directory_name = "#{directory_name}/#{today.strftime("%Y%m%d")}#{"%09i" % $codClient}#{"%04i" % $numOrder}.PED"}", "w")
    out_file.puts("01#{'%-6s' % 1.02}#{$clientCnpjOrder}#{"%06i" % $codClient}#{"%09i" % $numOrder}#{date}#{"%02i" % today.hour}#{"%02i" % today.min}#{"%04i" % $marketingPolicyId}#{"%03i" % $deadlineId.to_i}#{$establishmentCnpj.to_s}")
    out_file.puts("02[#{$currentUserName}: *#{$comment}*]") # 40

    total = 0
    total_units = 0
    OrderItems.where("order_id = ?", order.id).each do |item|
      total += 1
      total_units += item.quantity
      out_file.puts("031#{"%013i" % item.product_id}#{"%07i" % item.quantity}00#{"%04i" % item.marketing_policy_id}")
    end

    out_file.puts("09#{"%04i" % total}#{"%08i" % total_units}00")
    out_file.close
   
    send_ftp directory_name

  end

end


