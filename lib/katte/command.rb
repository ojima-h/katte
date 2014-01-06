require 'date'

class Katte
  class Command
    def self.env(period = 'day')
      {
        'today' => Date.today.strftime('%Y-%m-%d'),
      }
    end

    def self.open(node)
      @io_null ||= File.open('/dev/null')

      if Katte.config.mode == 'test'
        yield env, (Katte.debug.out || @io_null), (Katte.debug.err || @io_null)
      else
        out = File.open(File.join(Katte.config.result_root, node.name, 'w'))
        err = File.open(File.join(Katte.config.log_root   , node.name, 'a'))

        yield env, out, err
      end
    end
  end
end
