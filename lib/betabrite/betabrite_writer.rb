class BetabriteWriter
  def self.display(node, message, color = "00FF00")
    begin
      Timeout.timeout(10) do
        BetaBrite::USB.new do |sign|
          sign.stringfile(node) do
            print string(message + " ").rgb(color)
          end
        end.write!
      end
    rescue StandardError, Timeout::Error => e
      puts "Error sending message to Betabrite, #{e}"
    end
  end
end
    