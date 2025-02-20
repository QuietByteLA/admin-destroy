name: Destroy Terraform Resources

on:
  workflow_dispatch:

jobs:
  destroy:
    runs-on: ubuntu-latest
    permissions:
      id-token: write
      contents: read

    steps:
      - name: Checkout el repo principal con Terraform
        uses: actions/checkout@v4
        with:
          repository: TU_USUARIO_GITHUB/proyecto_principal
          token: ${{ secrets.GH_PAT }}

      - name: Configure AWS Credentials
        uses: aws-actions/configure-aws-credentials@v3
        with:
          role-to-assume: arn:aws:iam::267816782242:role/rol_github
          role-session-name: github-actions
          aws-region: us-east-1

      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v2
        with:
          terraform_version: 1.6.0

      - name: Initialize Terraform
        run: |
          cd infra
          terraform init

      - name: Destroy All Terraform Resources
        run: |
          cd infra
          terraform destroy -auto-approve -var-file=staging.tfvars
