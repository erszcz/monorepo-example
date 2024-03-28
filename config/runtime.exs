# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of the Config module.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
import Config

# Sample configuration:
#
#     config :logger, :console,
#       level: :info,
#       format: "$date $time [$level] $metadata$message\n",
#       metadata: [:user_id]

defmodule Monorepo.RuntimeConfig do
  def configure("service_c") do
    config :service_c, :service_c_option, System.fetch_env!("MONOREPO_SERVICE_C_OPTION")
  end

  def configure("service_d") do
    config :service_d, :service_d_option, System.fetch_env!("MONOREPO_SERVICE_D_OPTION")
  end
end

release_app = System.fetch_env!("MONOREPO_SERVICE")
Monorepo.RuntimeConfig.configure(release_app)
