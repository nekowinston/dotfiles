local lsp_present, lspconfig = pcall(require, "lspconfig")

if not lsp_present then
  return
end

local M = {}

M.setup = function(opts)
  lspconfig.jsonls.setup(vim.tbl_extend("keep", {
    settings = {
      json = {
        schemas = require("schemastore").json.schemas(),
        validate = { enable = true },
      },
    },
  }, opts))
  lspconfig.yamlls.setup(vim.tbl_extend("keep", {
    settings = {
      yaml = {
        completion = true,
        validate = true,
        suggest = {
          parentSkeletonSelectedFirst = true,
        },
        schemas = {
          ["https://json.schemastore.org/github-action"] = ".github/action.{yaml,yml}",
          ["https://json.schemastore.org/github-workflow"] = ".github/workflows/*",
          ["https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json"] = "*lab-ci.{yaml,yml}",
          ["https://json.schemastore.org/helmfile"] = "helmfile.{yaml,yml}",
          ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "docker-compose.yml.{yml,yaml}",
        -- stylua: ignore
        kubernetes = {
          '*-deployment.yaml', '*-deployment.yml', '*-service.yaml', '*-service.yml', 'clusterrole-contour.yaml',
          'clusterrole-contour.yml', 'clusterrole.yaml', 'clusterrole.yml', 'clusterrolebinding.yaml',
          'clusterrolebinding.yml', 'configmap.yaml', 'configmap.yml', 'cronjob.yaml', 'cronjob.yml', 'daemonset.yaml',
          'daemonset.yml', 'deployment-*.yaml', 'deployment-*.yml', 'deployment.yaml', 'deployment.yml', 'hpa.yaml',
          'hpa.yml', 'ingress.yaml', 'ingress.yml', 'job.yaml', 'job.yml', 'kubectl-edit-*.yaml', 'namespace.yaml',
          'namespace.yml', 'pvc.yaml', 'pvc.yml', 'rbac.yaml', 'rbac.yml', 'replicaset.yaml', 'replicaset.yml',
          'role.yaml', 'role.yml', 'rolebinding.yaml', 'rolebinding.yml', 'sa.yaml', 'sa.yml', 'secret.yaml',
          'secret.yml', 'service-*.yaml', 'service-*.yml', 'service-account.yaml', 'service-account.yml', 'service.yaml',
          'service.yml', 'serviceaccount.yaml', 'serviceaccount.yml', 'serviceaccounts.yaml', 'serviceaccounts.yml',
          'statefulset.yaml', 'statefulset.yml'
        },
        },
      },
      redhat = {
        telemetry = {
          enabled = false,
        },
      },
    },
  }, opts))
end

return M
