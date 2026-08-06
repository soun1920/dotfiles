local ls = require("luasnip")
local parse = ls.parser.parse_snippet

return {
    parse("rclcppnode", [[
#include <rclcpp/rclcpp.hpp>

class ${1:MyNode} : public rclcpp::Node
{
public:
  $1()
  : Node("${2:my_node}")
  {
    $0
  }

private:
};

int main(int argc, char * argv[])
{
  rclcpp::init(argc, argv);
  rclcpp::spin(std::make_shared<$1>());
  rclcpp::shutdown();
  return 0;
}
]]),

    parse("rclcpppubm", [[
rclcpp::Publisher<${1:msg_type}>::SharedPtr ${2:publisher_};
]]),

    parse("rclcpppub", [[
${1:publisher_} = this->create_publisher<${2:msg_type}>("${3:topic}", ${4:10});
]]),

    parse("rclcppsubm", [[
rclcpp::Subscription<${1:msg_type}>::SharedPtr ${2:subscription_};
]]),

    parse("rclcppsub", [[
${1:subscription_} = this->create_subscription<${2:msg_type}>(
  "${3:topic}", ${4:10}, std::bind(&${5:ClassName}::${6:topic_callback}, this, std::placeholders::_1));
]]),

    parse("rclcppsubcb", [[
void ${1:topic_callback}(const ${2:msg_type}::SharedPtr msg)
{
  $0
}
]]),

    parse("rclcpptimerm", [[
rclcpp::TimerBase::SharedPtr ${1:timer_};
]]),

    parse("rclcpptimer", [[
${1:timer_} = this->create_wall_timer(${2:500ms}, std::bind(&${3:ClassName}::${4:timer_callback}, this));
]]),

    parse("rclcpptimercb", [[
void ${1:timer_callback}()
{
  $0
}
]]),

    parse("rclcppsrvm", [[
rclcpp::Service<${1:srv_type}>::SharedPtr ${2:service_};
]]),

    parse("rclcppsrv", [[
${1:service_} = this->create_service<${2:srv_type}>(
  "${3:service_name}", std::bind(&${4:ClassName}::${5:service_callback}, this, std::placeholders::_1, std::placeholders::_2));
]]),

    parse("rclcppsrvcb", [[
void ${1:service_callback}(
  const std::shared_ptr<${2:srv_type}::Request> request,
  std::shared_ptr<$2::Response> response)
{
  $0
}
]]),

    parse("rclcppclim", [[
rclcpp::Client<${1:srv_type}>::SharedPtr ${2:client_};
]]),

    parse("rclcppcli", [[
${1:client_} = this->create_client<${2:srv_type}>("${3:service_name}");
]]),
}
