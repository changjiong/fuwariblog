# 构建阶段
FROM node:18-alpine as build

WORKDIR /app

# 安装依赖
COPY package*.json ./
COPY pnpm-lock.yaml ./
RUN npm install -g pnpm
RUN pnpm install

# 复制源码
COPY . .

# 构建项目
RUN pnpm run build

# 生产环境
FROM node:18-alpine as production
WORKDIR /app
COPY --from=build /app/dist ./dist
COPY --from=build /app/package*.json ./
COPY --from=build /app/pnpm-lock.yaml ./
RUN npm install -g pnpm
RUN pnpm install --prod
CMD ["pnpm", "run", "start"]