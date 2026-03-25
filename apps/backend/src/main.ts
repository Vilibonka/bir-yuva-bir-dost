import { NestFactory } from "@nestjs/core";
import { AppModule } from "./app.module";

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  const port = Number(process.env.PORT ?? 3000);

  await app.listen(port);
  console.log(`Bir Yuva Bir Dost backend http://localhost:${port} adresinde calisiyor.`);
}

void bootstrap();
