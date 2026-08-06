local ls = require("luasnip")
local parse = ls.parser.parse_snippet

return {
    parse("rclpynode", [[
import rclpy
from rclpy.node import Node


class ${1:MyNode}(Node):
    def __init__(self):
        super().__init__('${2:my_node}')
        $0


def main(args=None):
    rclpy.init(args=args)
    node = $1()
    rclpy.spin(node)
    node.destroy_node()
    rclpy.shutdown()


if __name__ == '__main__':
    main()
]]),

    parse("rclpypub", [[
self.${1:publisher_} = self.create_publisher(${2:msg_type}, '${3:topic}', ${4:10})
]]),

    parse("rclpysub", [[
self.${1:subscription} = self.create_subscription(
    ${2:msg_type},
    '${3:topic}',
    self.${4:listener_callback},
    ${5:10})
self.$1  # prevent unused variable warning

def $4(self, msg):
    $0
]]),

    parse("rclpytimer", [[
self.${1:timer} = self.create_timer(${2:0.5}, self.${3:timer_callback})

def $3(self):
    $0
]]),

    parse("rclpysrv", [[
self.${1:srv} = self.create_service(${2:ServiceType}, '${3:service_name}', self.${4:service_callback})

def $4(self, request, response):
    $0
    return response
]]),

    parse("rclpycli", [[
self.${1:cli} = self.create_client(${2:ServiceType}, '${3:service_name}')
while not self.$1.wait_for_service(timeout_sec=1.0):
    self.get_logger().info('service not available, waiting again...')
self.req = $2.Request()
]]),
}
