<template>
  <q-page class="flex flex-center">
     <q-form
      autocorrect="off"
      autocapitalize="off"
      autocomplete="off"
      spellcheck="false"
      greedy
      @submit="onSubmit"
      @reset="onReset"
    >
      <q-card
        flat
        bordered
        style="width: 900px;"
      >
        <q-item>
          <q-item-section avatar>
            <img src="~assets/logo.png">
          </q-item-section>

          <q-item-section>
            <q-item-label>{{ $t('title') }}</q-item-label>
            <q-item-label caption>{{ $t('subtitle') }}</q-item-label>
          </q-item-section>
        </q-item>

        <q-separator />

        <q-banner
          v-if="error"
          class="text-white bg-negative"
        >{{
          error
        }}</q-banner>

        <q-card-section>
          <q-file
            filled
            lazy-rules
            accept=".xml"
            counter
            v-model="model.citaviFile"
            :label="`${$t('form.modsXml')}*`"
            :hint="$t('form.modsXmlHint')"
            :rules="[(val) => !!val || $t('form.validation.required')]"
            :counter-label="showSize"
          />
        </q-card-section>

        <q-card-actions>
          <q-btn
            :label="$t('form.submit')"
            type="submit"
            color="primary"
          />
          <q-btn
            :label="$t('form.reset')"
            type="reset"
            color="primary"
            flat
            class="q-ml-sm"
          />
        </q-card-actions>
      </q-card>

    </q-form>

    <XmlDialog
      v-model="showDialog"
      :xml="transformedXml"
      @close="onCancel"
    />
  </q-page>
</template>

<script>
import {
  defineComponent, ref, toRaw,
} from 'vue';
import { transformXML } from 'src/helpers';
import XmlDialog from 'src/components/XmlDialog.vue';

export default defineComponent({
  components: { XmlDialog },
  setup() {
    const model = ref({
      citaviFile: null,
    });
    const error = ref('');
    const showDialog = ref(false);
    const transformedXml = ref('');

    const onSubmit = () => {
      const unwrapped = toRaw(model.value);
      transformXML(unwrapped.citaviFile)
        .then((xmlString) => {
          transformedXml.value = xmlString;
          showDialog.value = true;
        });
    };

    const onReset = () => {
      model.value = {
        citaviFile: null,
      };
    };

    const onCancel = () => {
      showDialog.value = false;
      transformXML.value = '';
      onReset();
    };

    const showSize = ({ totalSize }) => totalSize;

    return {
      model,
      error,
      onSubmit,
      onReset,
      showSize,
      onCancel,
      showDialog,
      transformedXml,
    };
  },
});
</script>
