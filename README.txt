JHORDANNA ARAÚJO — SISTEMA DE AGENDAMENTO

Stack: HTML/CSS/JavaScript + Cloudflare Worker + D1.

1) Criar banco D1 no Cloudflare:
   wrangler d1 create jhordanna-agendamento

2) Copiar o database_id retornado para wrangler.jsonc.

3) Aplicar o banco:
   wrangler d1 execute jhordanna-agendamento --remote --file=./schema.sql

4) Configurar segredo do painel:
   wrangler secret put ADMIN_PASSWORD

5) Para e-mails automáticos, criar conta no Resend e configurar:
   wrangler secret put RESEND_API_KEY
   wrangler secret put FROM_EMAIL
   FROM_EMAIL deve ser um remetente/domínio verificado no provedor.

6) Publicar:
   npx wrangler deploy

URLs:
   /              agenda pública
   /status.html   consulta por token
   /admin.html    painel administrativo

IMPORTANTE:
- O sistema funciona sem Resend, mas os e-mails ficarão registrados como "skipped" até configurar as credenciais.
- O e-mail administrativo já está definido como jhordannaaraujo7@gmail.com.
- Horários: seg-sex 08:30-18:00, sáb 08:30-16:00, domingo fechado.
- Antecedência: 48h. Buffer: 30 min. Pendência: 12h. Cancelamento: 48h.
