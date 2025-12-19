return {
  settings = {
    yaml = {
      trace = { server = "verbose" },
      format = {
        enable = false,
      },
      -- hover = true,
      -- completion = true,
      schemas = {
        -- kubernetes = {
        --   "k8s/**/*.{yaml,yml}", -- basically only for my homelab lol
        --   "hack/**/*.{yaml,yml}",
        -- },
        -- kubernetes = "*.{yaml,yml}",
        ["http://json.schemastore.org/github-workflow"] = ".github/workflows/**/*.{yaml,yml}",
        ["http://json.schemastore.org/github-action"] = {
          "/.github/actions/**/*.{yaml,yml}",
          -- "/.github/action*.{yml,yaml}",
          -- "/.github/**/*.{yaml,yml}",
        },
        ["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
        ["http://json.schemastore.org/chart.json"] = "Chart.yaml",
        ['https://raw.githubusercontent.com/docker/compose/master/compose/config/compose_spec.json'] =
        'docker-compose*.{yml,yaml}',
        -- ["https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/argoproj.io/application_v1alpha1.json"] =
        -- "argocd-application.yaml",
      },
      schemaDownload = { enable = true },
      validate = true,
    },
  }
}
